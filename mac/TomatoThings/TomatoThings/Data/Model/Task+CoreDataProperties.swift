//
//  Task+CoreDataProperties.swift
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

extension Task {

    @NSManaged var addition: String?
    @NSManaged var content: String?
    @NSManaged var createTime: NSDate?
    @NSManaged var estimateNUMT: NSNumber?
    @NSManaged var title: String?
    @NSManaged var log: TaskLog?

}
