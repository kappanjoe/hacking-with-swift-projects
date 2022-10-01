//
//  ViewController.swift
//  Project28
//
//  Created by Joseph Van Alstyne on 9/30/22.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication required to access dirty secrets. Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You don't look like yourself. Try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            if KeychainWrapper.standard.string(forKey: "Password")?.count ?? 5 < 4 {
                setPassword()
            } else {
                checkPassword()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        title = "Nothing suspicious here..."
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func showErrorAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Fine", style: .default))
        present(ac, animated: true)
    }
    
    func setPassword() {
        let ac = UIAlertController(title: "Set a password", message: "Make it memorable - if you forget it and can't use biometrics to unlock, you'll lose access to your secrets. Must be longer than 3 characters.", preferredStyle: .alert)
        
        ac.addTextField()
        ac.addTextField()
        ac.textFields?[0].placeholder = "Enter password"
        ac.textFields?[0].isSecureTextEntry = true
        ac.textFields?[1].placeholder = "Confirm password"
        ac.textFields?[1].isSecureTextEntry = true
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            // This stuff should probably encrypted somehow, but that's for a different project 🤷🏻
            guard let entry = ac?.textFields?[0].text else { return }
            guard let confirmation = ac?.textFields?[1].text else { return }
            guard entry == confirmation else {
                self?.showErrorAlert(title: "Did Not Match", message: "Your password confirmation did not match. Please try again.")
                return
            }
            
            if entry.count < 4 || confirmation.count < 4 {
                self?.showErrorAlert(title: "Too Short", message: "Your password should be 4 or more characters in length.")
            } else {
                KeychainWrapper.standard.set(entry, forKey: "Password")
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func checkPassword() {
        let ac = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        ac.textFields?[0].placeholder = "Enter password"
        ac.textFields?[0].isSecureTextEntry = true
        
        ac.addAction(UIAlertAction(title: "Unlock", style: .default) { [weak self, weak ac] action in
            // Again, this stuff should probably encrypted somehow, but that's for a different project 🤷🏻
            guard let entry = ac?.textFields?[0].text else { return }
            guard let check = KeychainWrapper.standard.string(forKey: "Password") else { return }
            
            if entry == "reset" {
            #if targetEnvironment(simulator)
                KeychainWrapper.standard.set("", forKey: "Password")
                self?.showErrorAlert(title: "Password Reset", message: "We'll ask you for a new one next time.")
            #else
                self?.showErrorAlert(title: "Wrong Password", message: "Try again? Or don't; you probably forgot and will never be able to access your secrets again.")
            #endif
            } else if entry != check {
                self?.showErrorAlert(title: "Wrong Password", message: "Try again? Or don't; you probably forgot and will never be able to access your secrets again.")
            } else {
                self?.unlockSecretMessage()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secrets exposed!"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(saveSecretMessage))
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        if KeychainWrapper.standard.string(forKey: "Password")?.count ?? 5 < 4 {
            setPassword()
        }
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing suspicious here..."
        navigationItem.leftBarButtonItem = nil
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
    }
}

