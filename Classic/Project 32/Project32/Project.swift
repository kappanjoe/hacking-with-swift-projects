//
//  Project.swift
//  Project32
//
//  Created by Joseph Van Alstyne on 11/17/22.
//

import UIKit

class Project: NSObject, Codable {
    var title: String
    var subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}
