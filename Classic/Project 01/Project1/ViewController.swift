//
//  ViewController.swift
//  Project1
//
//  Created by Joseph Van Alstyne on 7/24/22.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var views: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        let defaults = UserDefaults.standard
        if let viewsDict = defaults.dictionary(forKey: "views") as? [String: Int] {
            views = viewsDict
        }
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                if views[item] == nil {
                    views[item] = 0
                }
            }
        }
        
        pictures.sort()
        save()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        let viewCount: Int = views[pictures[indexPath.row]] ?? 0
        cell.detailTextLabel?.text = "Views: \(viewCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: Try loading the "Detail" view controller typecasted to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: Success! Set selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedIndex = indexPath.row
            vc.imageCount = pictures.count
            views[pictures[indexPath.row]]? += 1
            save()
            self.tableView.reloadData()
            // 3: Push onto navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(views, forKey: "views")
    }

}

