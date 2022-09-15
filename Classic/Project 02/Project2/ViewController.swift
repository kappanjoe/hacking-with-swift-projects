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
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerLocal()
        scheduleLocal()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(checkScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
        
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
    
    @IBAction func startTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    @IBAction func endTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            sender.transform = .identity
        })
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
            displayAlert(title: title ?? "", message: "\(correction)Your score is \(score).", buttonLabel: "Continue", continueGame: true)
        } else {
            var message = "Your final score is \(score)."
            if score >= 10 {
                message += " Congratulations! You scored perfectly!"
            }
            if score > highScore {
                message += " New high score!"
                highScore = score
                save()
            }
            displayAlert(title: "Finished!", message: message, buttonLabel: "Restart", continueGame: true)
            label.text = ""
            score = 0
            tries = 0
        }
    }
    
    @objc func checkScore() {
        displayAlert(title: "Paused", message: "Your current score is \(score).\nYour highest score is \(highScore).", buttonLabel: "Resume")
    }
    
    func displayAlert(title: String, message: String, buttonLabel: String, continueGame: Bool = false) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if continueGame {
            ac.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: askQuestion))
        } else {
            ac.addAction(UIAlertAction(title: buttonLabel, style: .default))
        }
        present(ac, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications authorized.")
            } else {
                print("Notifications denied.")
            }
        }
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "⏳ Time to play!"
        content.body = "Ready to play today's game? 👀"
        content.categoryIdentifier = "remind"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }

}

