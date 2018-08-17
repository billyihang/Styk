//
//  User.swift
//  Styk
//
//  Created by William Yang on 8/16/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation

enum pickedColor: String {
    case green = "71D25E"
}

class User {
    var name: String?
    var color: pickedColor?
    
    var projects: [Project]?
    
    
}
