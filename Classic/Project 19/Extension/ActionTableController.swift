//
//  ActionTableController.swift
//  Extension
//
//  Created by Joseph Van Alstyne on 9/14/22.
//

import UIKit

class ActionTableController: UITableViewController {
    
    var scripts: [String: Script]?
    var scriptsArr = [Script]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Custom Scripts"
        
        scriptsArr = (scripts?.map({ key, value in
            return value
        }))!
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptsArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scriptsArr: [Script] = (scripts?.map({ key, value in
            return value
        }))!
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = scriptsArr[indexPath.row].name
        cell.detailTextLabel?.text = scriptsArr[indexPath.row].script
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Editor") as? ActionViewController {
            vc.currentScript = scriptsArr[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
