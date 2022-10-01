//
//  ViewController.swift
//  Project10
//
//  Created by Joseph Van Alstyne on 8/1/22.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlock", style: .plain, target: self, action: #selector(authenticate))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lockUp), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let acSelector = UIAlertController(title: "Edit Person", message: nil, preferredStyle: .actionSheet)
        acSelector.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadItems(at: [indexPath])
                self?.save()
            })
            
            self?.present(ac, animated: true)
        })
        acSelector.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            let dc = UIAlertController(title: "Confirm Deletion", message: "This action cannot be reversed.", preferredStyle: .alert)
            dc.addAction(UIAlertAction(title: "Keep", style: .default))
            dc.addAction(UIAlertAction(title: "DELETE", style: .destructive) { [weak self] _ in
                self?.people.remove(at: indexPath.item)
                self?.collectionView.deleteItems(at: [indexPath])
                self?.save()
            })
            
            self?.present(dc, animated: true)
        })
        acSelector.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                             
        present(acSelector, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
// iOS 16 Simulator seems to think it has a camera? idk.
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        }
        present(picker, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication required to access contacts. Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.loadPeople()
                        self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lock", style: .done, target: self, action: #selector(self?.lockUp))
                        self?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.addNewPerson))
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You don't look like yourself. Try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometrics Unavailable", message: "Your phone doesn't have Face ID or Touch ID and honestly why???", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func lockUp() {
        people = []
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.deleteItems(at: self!.collectionView.indexPathsForVisibleItems)
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlock", style: .plain, target: self, action: #selector(self?.authenticate))
            self?.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func loadPeople() {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }


}

