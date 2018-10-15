//
//  User+CoreDataProperties.swift
//  Styk
//
//  Created by William Yang on 10/14/18.
//  Copyright © 2018 William Yang. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var favoriteColor: NSObject?
    @NSManaged public var favoriteColorName: String?

}
