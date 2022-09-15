//
//  Script.swift
//  Extension
//
//  Created by Joseph Van Alstyne on 9/14/22.
//

import UIKit

class Script: NSObject, Codable {
    var name: String
    var script: String
    
    init(name: String, script: String) {
        self.name = name
        self.script = script
    }
}
