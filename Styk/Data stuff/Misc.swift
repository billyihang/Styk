//
//  Misc.swift
//  Styk
//
//  Created by William Yang on 8/16/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Color enum
enum pickedColor: String {
    case green = "71D25E"
    case red = "FF0000"
    case maroon = "800000"
    case yellow = "FFFF00"
    case olive = "808000"
    case lime = "00FF00"
    case aqua = "00FFFF"
    case teal = "008080"
    case blue = "0000FF"
    case navy = "000080"
    case fuchsia = "FF00FF"
    case purple = "800080"
    
}

// Color functions
class Color {
    // Convert from hex to UIColor
    static func toUIColor(_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Generate random color
    static func randomColorName() -> String {
        
        let array = ["Red", "Maroon", "Yellow", "Orange", "Olive", "Lime", "Green", "Aqua", "Teal", "Blue", "Navy", "Magenta", "Purple"]
        let randomNum = Int(arc4random_uniform(13))
        
        return array[randomNum]
        
        // Random hex value
        
        /*
        let array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        let redValue = array[Int(arc4random_uniform(16))] + array[Int(arc4random_uniform(16))]
        let blueValue = array[Int(arc4random_uniform(16))] + array[Int(arc4random_uniform(16))]
        let greenValue = array[Int(arc4random_uniform(16))] + array[Int(arc4random_uniform(16))]
        
        return redValue + greenValue + blueValue
 */
    }
    
    // Name to hex
    static func toHex(_ colorName: String) -> String {
        if colorName.elementsEqual("Green") {
            return "165b05"
        } else if colorName.elementsEqual("Red") {
            return "fb4353"
        } else if colorName.elementsEqual("Maroon") {
            return "702424"
        } else if colorName.elementsEqual("Yellow") {
            return "fded6c"
        } else if colorName.elementsEqual("Orange") {
            return "ff6500"
        } else if colorName.elementsEqual("Olive") {
            return "848214"
        } else if colorName.elementsEqual("Lime") {
            return "14E614"
        } else if colorName.elementsEqual("Aqua") {
            return "14F1FC"
        } else if colorName.elementsEqual("Teal") {
            return "138d8d"
        } else if colorName.elementsEqual("Blue") {
            return "0f6aff"
        } else if colorName.elementsEqual("Navy") {
            return "001199"
        } else if colorName.elementsEqual("Magenta") {
            return "E600E6"
        }  else if colorName.elementsEqual("Purple"){
            return "641363"
        } else {
            return "000000"
        }
    }
    
    static func toName(colorHex: String) -> String {
        if colorHex.elementsEqual("165b05") {
            return "Green"
        } else if colorHex.elementsEqual("fb4353") {
            return "Red"
        } else if colorHex.elementsEqual("702424") {
            return "Maroon"
        } else if colorHex.elementsEqual("fded6c") {
            return "Yellow"
        } else if colorHex.elementsEqual("ff6500") {
            return "Orange"
        } else if colorHex.elementsEqual("848214") {
            return "Olive"
        } else if colorHex.elementsEqual("14E614") {
            return "Lime"
        } else if colorHex.elementsEqual("14F1FC") {
            return "Aqua"
        } else if colorHex.elementsEqual("138d8d") {
            return "Teal"
        } else if colorHex.elementsEqual("0f6aff") {
            return "Blue"
        } else if colorHex.elementsEqual("001199") {
            return "Navy"
        } else if colorHex.elementsEqual("E600E6") {
            return "Magenta"
        }  else if colorHex.elementsEqual("641363"){
            return "Purple"
        } else {
            return "Black"
        }
    }
    
}


// IndexPath class
class TaskIndexPath {
    var indexPath: IndexPath?
    var projectIndex: Int?
    var taskIndex: Int?
    
    init(projectIndex: Int, taskIndex: Int) {
        self.projectIndex = projectIndex
        self.taskIndex = taskIndex
    }
    
    init(iPath: IndexPath) {
        self.indexPath = iPath
    }
}

// UIView functions
extension UIView {
    func startRotating(duration: Double, start: Float) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = start
            animate.toValue = Float(Float.pi * 2.0 + start)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
}

extension UIBezierPath {
    convenience init(circleSegmentCenter center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)
    {
        self.init()
        self.move(to: center)
        self.addArc(withCenter: center, radius:radius, startAngle:startAngle, endAngle: endAngle, clockwise:true)
        self.close()
    }
}

/*
struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}
*/

// Calendar stuff
//https://cocoapods.org/pods/JTAppleCalendar
//https://www.appcoda.com/ios-event-kit-programming-tutorial/

// Data functions to delete later
/*
class tempDataSource {
    static func getProjects() -> [Project] {
        var projects = [Project]()
        var project1 = Project("Today")
        project1.tasks = [Task("Do this stuff", dateTime: Calendar.current.dateComponents( [.year, .month, .day, .hour, .minute], from: Date()), project: project1), Task("Programming", dateTime: Calendar.current.dateComponents( [.year, .month, .day, .hour, .minute], from: Date()), project: project1)]
        var project2 = Project("General")
        project2.tasks = [Task("Do more stuff", dateTime: Calendar.current.dateComponents( [.year, .month, .day, .hour, .minute], from: Date()), project: project2), Task("More programming", dateTime: Calendar.current.dateComponents( [.year, .month, .day, .hour, .minute], from: Date()), project: project2), Task("Do general stuff", dateTime: Calendar.current.dateComponents( [.year, .month, .day, .hour, .minute], from: Date()), project: project2)]
        
        projects.append(project1)
        projects.append(project2)
        
        return projects
    }
}
 */
