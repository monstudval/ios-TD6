//
//  Student+CoreDataProperties.swift
//  DemoCoreData2
//
//  Created by Derbalil on 2017-10-04.
//  Copyright © 2017 Derbalil. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var fullName: String?
    @NSManaged public var age: Int16

}
