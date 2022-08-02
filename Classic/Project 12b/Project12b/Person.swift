//
//  Person.swift
//  Project10
//
//  Created by Joseph Van Alstyne on 8/1/22.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
