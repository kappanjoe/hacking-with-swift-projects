//
//  ViewController.swift
//  Project31
//
//  Created by Joseph Van Alstyne on 11/15/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Press + to create a new web view."
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    // Flip stack depending on width available
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func updateUI(for webView: WKWebView) {
        title = webView.title
        addressBar.text = webView.url?.absoluteString ?? ""
    }
    
    // Calls updateUI using didFinish from webView (accessible as WKNavigationDelegate)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    @objc func addWebView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Safely unwrap selected webView and address string
        if let webView = activeWebView, var address = addressBar.text {
            // Only continue if url is valid
            if address.hasPrefix("http://") {
                address.removeFirst(7)
            }
            
            if !address.hasPrefix("https://") {
                address = "https://" + address
            }
            
            if let url = URL(string: address) {
                // Load address
                webView.load(URLRequest(url: url))
            }
        }

        // Resign text field focus
        textField.resignFirstResponder()
        return true
    }
    
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        updateUI(for: webView)
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func deleteWebView() {
        // Safely unwrap selected webView
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
                // Remove and destroy selected webView
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    // Return to default
                    setDefaultTitle()
                } else {
                    // Convert index to integer
                    var currentIndex = Int(index)
                    
                    // Subtract one if last view in stack
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    // Select view at currentIndex
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }


}

