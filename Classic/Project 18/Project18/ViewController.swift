//
//  ViewController.swift
//  Project18
//
//  Created by Joseph Van Alstyne on 9/13/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Prints messages to console log. Included in release.
//        print(1, 2, 3, 4, 5, separator: "-")
//        print("Some message", terminator: "")
//        print(". End of viewDidLoad.")
//
//        // Prints message when expression evaluates to false. Disabled in release.
//        // "Assertions are like running your code in strict mode."
//        assert(1 == 1, "Math failure?")
//        assert(1 == 2, "Math failure!") <-- Only this message will print.
        
        // Breakpoints suspend the app processes at a specific line of code to allow checking variable states, etc. Dark blue = enabled. Light blue = disabled.
        // "Step Over" (F6) to advance line-by-line, or "Continue" (Ctrl+Cmd+Y) to advance until next breakpoint.
        // In lldb console, type "p variableName" to reveal value
        // Right-click breakpoint to edit conditions
        // View Breakpoint Navigator to see Exception Breakpoints
        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

