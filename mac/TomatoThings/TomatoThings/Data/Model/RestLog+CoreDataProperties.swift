//
//  RestLog+CoreDataProperties.swift
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

extension RestLog {

    @NSManaged var endDate: TimeInterval
    @NSManaged var fixedDuration: Double
    @NSManaged var startDate: TimeInterval
    @NSManaged var task: Task?

}
