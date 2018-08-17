//
//  Projects.swift
//  Styk
//
//  Created by William Yang on 8/16/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation

class Project {
    
    var name: String?
    var tasks: [ToDoItem] = [ToDoItem]()
    var color: pickedColor?
    
    init(_ userName: String) {
        name = userName
    }
}
