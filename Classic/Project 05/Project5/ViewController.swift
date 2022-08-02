//
//  ViewController.swift
//  Project5
//
//  Created by Joseph Van Alstyne on 7/27/22.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    var savedWords: [String: [String]] = ["words": [], "usedWords": []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.dictionary(forKey: "savedWords") == nil {
            defaults.set(savedWords, forKey: "savedWords")
        } else {
            savedWords = defaults.dictionary(forKey: "savedWords") as! [String: [String]]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }

        if let currentWord = savedWords["clue"]?[0] as? String {
            if let savedUsedWords = savedWords["usedWords"] {
                if currentWord != "" {
                    title = currentWord
                    usedWords = savedUsedWords
                    tableView.reloadData()
                } else {
                    startGame()
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        let newClue: String! = allWords.randomElement()
        title = newClue
        savedWords["clue"] = [newClue]
        savedWords["usedWords"]?.removeAll(keepingCapacity: true)
        save()
        
        usedWords.removeAll(keepingCapacity: true)
        tableView.deleteRows(at: tableView.indexPathsForVisibleRows ?? [], with: .automatic)
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    savedWords["usedWords"] = usedWords
                    save()
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorAlert(title: "Word not found / Too short", message: "Stop making 💩 up.")
                }
            } else {
                showErrorAlert(title: "Word already used", message: "Have an original thought, for once...")
            }
        } else {
            showErrorAlert(title: "Word not possible", message: "You can't spell that using the individual letters in \"\(title!)\", doofus.")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if usedWords.contains(word) || word == title {
            return false
        } else { return true }
    }
    
    func isReal(word: String) -> Bool {
        if word.utf16.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Fine", style: .default))
        present(ac, animated: true)
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(savedWords, forKey: "savedWords")
    }

}

