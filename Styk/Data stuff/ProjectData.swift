//
//  ProjectData.swift
//  Styk
//
//  Created by William Yang on 10/11/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation
import UIKit

class ProjectData {
    
    var name = ""
    var color: UIColor!
    var deletable = false
    var colorString = ""
    
    var tasks = [Task]()
    
    init(title: String, clr: UIColor, clrName: String) {
        self.name = title
        self.color = clr
        self.colorString = clrName
    }
    
    init(title: String, clr: UIColor, clrName: String, delete: Bool) {
        self.name = title
        self.color = clr
        self.colorString = clrName
        self.deletable = delete
    }
    
    static func createProjects() -> [ProjectData]{
        var array = [ProjectData]()
        
        var colorName = Color.randomColorName()
        var colorHex = Color.toHex(colorName)
        var color = Color.toUIColor(colorHex)
        let project1 = ProjectData(title: "Today", clr: color, clrName: colorName)
        array.append(project1)
        
        colorName = Color.randomColorName()
        colorHex = Color.toHex(colorName)
        color = Color.toUIColor(colorHex)
        let project2 = ProjectData(title: "General", clr: color, clrName: colorName)
        array.append(project2)
        
        return array
    }
}
