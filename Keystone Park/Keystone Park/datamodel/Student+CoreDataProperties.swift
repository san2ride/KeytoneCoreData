//
//  Student+CoreDataProperties.swift
//  Keystone Park
//
//  Created by Jason Sanchez on 9/10/18.
//  Copyright © 2018 Jason Sanchez. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String
    @NSManaged public var lesson: Lesson

}
