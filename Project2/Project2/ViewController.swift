//
//  ViewController.swift
//  Project2
//
//  Created by Joseph Van Alstyne on 7/25/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var label: UILabel!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var tries = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        tries += 1
        var correction = ""
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            label.text = "Score: \(score)"
        } else {
            title = "Wrong"
            score -= 1
            label.text = "Score: \(score)"
            correction += "Sorry, that was the flag of \(countries[sender.tag].uppercased()). "
        }
        
        if tries < 10 {
            let ac = UIAlertController(title: title, message: "\(correction)Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            var message = "Your final score is \(score)."
            if score >= 10 {
                message += " Congratulations! You scored perfectly!"
            }
            let ac = UIAlertController(title: "Finished!", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            present(ac, animated: true)
            label.text = ""
            score = 0
            tries = 0
        }
    }
    

}

