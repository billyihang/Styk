//
//  Task+CoreDataProperties.swift
//  Styk
//
//  Created by William Yang on 10/14/18.
//  Copyright © 2018 William Yang. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var project: Project?

}
