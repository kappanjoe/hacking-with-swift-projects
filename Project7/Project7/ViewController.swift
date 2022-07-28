//
//  ViewController.swift
//  Project7
//
//  Created by Joseph Van Alstyne on 7/28/22.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var inputPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 1 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            inputPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = inputPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
// // // // // TO-DO: Fix filtering - self is assigning to AppDelegate?
    
//    @objc func filterPetitions() {
//        let ac = UIAlertController(title: "Search for:", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//        let submitAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] action in
//            guard let searchTerm = ac?.textFields?[0].text else { return }
//            self?.inputPetitions = self?.petitions.filter({ petition in
//                if petition.title.contains(searchTerm) || petition.body.contains(searchTerm) {
//                    return true
//                } else { return false }
//            }) ?? []
//            self?.tableView.reloadData()
//        }
//        ac.addAction(submitAction)
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(ac, animated: true)
//    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Data in this app was originally sourced from the We The People API provided by The White House of the United States of America.\n\nThe data is currently hosted on and accessed from hackingwithswift.com.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}

