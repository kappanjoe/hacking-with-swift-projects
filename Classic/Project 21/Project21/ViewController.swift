//
//  ViewController.swift
//  Project21
//
//  Created by Joseph Van Alstyne on 9/15/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications authorized.")
            } else {
                print("Notifications denied.")
            }
        }
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wake-up Call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese... (What happened to the first mouse?)"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzBuzz"]
        content.sound = UNNotificationSound.default
        
        // Calendar Trigger Example //
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // To Remove Notifications //
//        center.removeAllPendingNotificationRequests()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Capture the userInfo dictionary (defined in notification content)
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // User swiped to open
                print("Default identifier")

            case "show":
                // User tapped "Tell me more..." button, i.e., "show" action
                print("Show more information…")

            default:
                break
            }
        }

        // Call the completion handler when you're done
        completionHandler()
    }

}

