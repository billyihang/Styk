//
//  BootcampTask+CoreDataProperties.swift
//  Styk
//
//  Created by William Yang on 10/14/18.
//  Copyright © 2018 William Yang. All rights reserved.
//
//

import Foundation
import CoreData


extension BootcampTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BootcampTask> {
        return NSFetchRequest<BootcampTask>(entityName: "BootcampTask")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var name: String?
    @NSManaged public var order: Int16
    @NSManaged public var taskLongDescription: String?
    @NSManaged public var taskShortDescription: String?
    @NSManaged public var imageName: String?

}
