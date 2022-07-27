//
//  TableViewController.swift
//  Project4
//
//  Created by Joseph Van Alstyne on 7/27/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var websites: [String] = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ほぼSafari"
        
        navigationController?.isToolbarHidden = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: Try loading the "Browser" view controller typecasted to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? ViewController {
            // 2: Success! Set selectedImage property
            vc.websites = websites
            vc.selectedIndex = indexPath.row
            // 3: Push onto navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
