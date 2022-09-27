//
//  ViewController.swift
//  Project25
//
//  Created by Joseph Van Alstyne on 9/26/22.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {

    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    var sessionPeers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        var leftSideItems = [UIBarButtonItem]()
        leftSideItems.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)))
        leftSideItems.append(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(listPeers)))
        navigationItem.leftBarButtonItems = leftSideItems
        
        var rightSideItems = [UIBarButtonItem]()
        rightSideItems.append(UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(promptForMessage)))
        rightSideItems.append(UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture)))
        navigationItem.rightBarButtonItems = rightSideItems
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    @objc func promptForMessage() {
        let ac = UIAlertController(title: "Enter Message:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Send", style: .default) { [weak self, weak ac] action in
            guard let message = ac?.textFields?[0].text else { return }
            self?.sendMessage(message)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // Check if we have an active session
        guard let mcSession = mcSession else { return }
        
        // Check if any peers are available
        if mcSession.connectedPeers.count > 0 {
            // Convert image to Data
            if let imageData = image.pngData() {
                // Send to all peers
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // Handle errors
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func sendMessage(_ message: String) {
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            let messageData = Data(message.utf8)
            do {
                try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to Peers", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: endSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func listPeers() {
        let ac = UIAlertController(title: "Connected Peers:", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        guard let mcSession = mcSession else {
            ac.message = "No session in progress."
            present(ac, animated: true)
            return
        }
        if mcSession.connectedPeers.count < 1 {
            ac.message = "No peers connected."
        } else if mcSession.connectedPeers.count > 0 {
            for peer in mcSession.connectedPeers {
                ac.message? += "\n" + peer.displayName
            }
        }
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func endSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcSession.disconnect()
        guard let mcNearbyServiceAdvertiser = mcNearbyServiceAdvertiser else { return }
        mcNearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Not in use
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Not in use
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Not in use
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            sessionPeers.append(peerID.displayName)
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            if sessionPeers.contains(peerID.displayName) {
                DispatchQueue.main.async { [weak self] in
                    let ac = UIAlertController(title: " \(peerID.displayName) disconnected.", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
                sessionPeers.remove(at: sessionPeers.firstIndex(of: peerID.displayName)!)
            }
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Receiving data may not be on the main thead - dispatch to main to manipulate user interface
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "Message from \(peerID.displayName)", message: text, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
}

