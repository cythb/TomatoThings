//
//  Task+CoreDataProperties.swift
//  
//
//  Created by tanghaibo on 16/2/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var addition: String?
    @NSManaged var completeTomatos: Int16
    @NSManaged var content: String?
    @NSManaged var createTime: TimeInterval
    @NSManaged var estimateNUMT: Int16
    @NSManaged var finishDate: TimeInterval
    @NSManaged var finished: Bool
    @NSManaged var incompleteTomatos: Int16
    @NSManaged var index: Int64
    @NSManaged var title: String?
    @NSManaged var logs: NSSet?
    @NSManaged var restLogs: NSSet?
    @NSManaged var category: NSManagedObject?

}
