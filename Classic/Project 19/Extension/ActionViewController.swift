//
//  ActionViewController.swift
//  Extension
//
//  Created by Joseph Van Alstyne on 9/13/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageHost = ""
    var scripts = [String: Script]()
    var currentScript: Script!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editName))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open...", style: .plain, target: self, action: #selector(selectScript))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                // Closure called with data received from extension
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    // Isolates data handled in Action.js
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageHost = URL(string: javaScriptValues["URL"] as! String)?.host! ?? ""
                    
                    // Initialize scripts and currentScript
                    let defaults = UserDefaults.standard
                    if let savedScripts = defaults.object(forKey: "scripts") as? Data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            self?.scripts = try jsonDecoder.decode([String: Script].self, from: savedScripts)
                        } catch {
                            print("Failed to load scripts.")
                            self?.scripts = ["www.apple.com": Script(name: "Show Title in Alert", script: "alert(document.title);")]
                        }
                    }
                    
                    if self?.scripts[self!.pageHost] != nil && self?.currentScript == nil {
                        self?.currentScript = self?.scripts[self!.pageHost]
                    } else if self?.currentScript == nil {
                        self?.currentScript = Script(name: self?.pageTitle ?? "Unnamed Script", script: "")
                    }
                    
                    DispatchQueue.main.async {
                        self?.title = self?.currentScript?.name
                        self?.script.text = self?.currentScript?.script
                    }
                }
            }
        }
    }
    
    @objc func saveScript() {
        // Return the inputted script to Safari to appear in the finalize() from Action.js
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        currentScript.script = script.text
        scripts.updateValue(currentScript, forKey: pageHost)
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(scripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scripts")
        } else {
            print("Failed to save scripts.")
        }

        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func editName() {
        let ac = UIAlertController(title: "Choose Script Name", message: "Pick a name you can easily recognize.", preferredStyle: .alert)
        ac.addTextField(configurationHandler: { [weak self] field in
            field.text = self?.currentScript.name
        })
        ac.addAction(UIAlertAction(title: "Save and Run", style: .default) { [weak self, weak ac] _ in
            self?.currentScript.name = ac?.textFields?[0].text ?? "Unnamed Script"
            self?.saveScript()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Quit without Saving", style: .destructive) { [weak self] _ in
            self?.extensionContext?.completeRequest(returningItems: nil)
        })
        present(ac, animated: true)
    }
    
    @objc func selectScript() {
        let ac = UIAlertController(title: "Open...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Premade Scripts", style: .default) { [weak self] _ in
            let premadeAC = UIAlertController(title: "Premade Scripts", message: "Select a premade example script to replace the current script content.", preferredStyle: .actionSheet)
            premadeAC.addAction(UIAlertAction(title: "Show Title in Alert", style: .default) { _ in
                self?.script.text = "alert(document.title);"
            })
            premadeAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(premadeAC, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Custom Scripts", style: .default) { [weak self] _ in
            if let tc = self?.storyboard?.instantiateViewController(withIdentifier: "Table") as? ActionTableController {
                tc.scripts = self?.scripts ?? [:]
                self?.navigationController?.pushViewController(tc, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
