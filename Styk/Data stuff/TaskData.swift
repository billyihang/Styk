//
//  TaskData.swift
//  Styk
//
//  Created by William Yang on 10/11/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation
import UIKit

class TaskData {
    
    var name: String!
    var startDate: Date?
    var endDate: Date?
    var project: Project?
    
    init(title: String, start: Date, end: Date) {
        self.name = title
        self.startDate = start
        self.endDate = end
    }
    
    init(title: String, end: Date) {
        self.name = title
        self.endDate = end
    }
    
    init(title: String) {
        self.name = title
    }
    
    init(title: String, start: Date, end: Date, proj: Project) {
        self.name = title
        self.startDate = start
        self.endDate = end
        self.project = proj
    }
    
    init(title: String, end: Date, proj: Project) {
        self.name = title
        self.endDate = end
        self.project = proj
    }
    
    init(title: String, proj: Project) {
        self.name = title
        self.project = proj
    }
    
}
