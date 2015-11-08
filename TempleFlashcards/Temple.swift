//
//  Temple.swift
//  TempleFlashcards
//
//  Created by Kyle on 11/7/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import UIKit

class Temple {
    var image: UIImage!
    var name: String!
    var hasBeenPicked: Bool!
    
    convenience init(filename: String, name: String) {
        self.init()
        self.image = UIImage(named: filename)
        self.name = name
        self.hasBeenPicked = false
    }
}