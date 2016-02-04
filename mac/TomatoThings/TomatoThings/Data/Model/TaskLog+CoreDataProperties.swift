//
//  TaskLog+CoreDataProperties.swift
//  
//
//  Created by tanghaibo on 16/2/4.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TaskLog {

    @NSManaged var startDate: NSDate?
    @NSManaged var finishDate: NSDate?
    @NSManaged var completeTomatos: NSNumber?
    @NSManaged var incompleteTomatos: NSNumber?
    @NSManaged var task: Task?

}
