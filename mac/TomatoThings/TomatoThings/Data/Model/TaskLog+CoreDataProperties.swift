//
//  TaskLog+CoreDataProperties.swift
//  
//
//  Created by tanghaibo on 16/2/6.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TaskLog {

    @NSManaged var startDate: TimeInterval
    @NSManaged var endDate: TimeInterval
    @NSManaged var task: Task?

}
