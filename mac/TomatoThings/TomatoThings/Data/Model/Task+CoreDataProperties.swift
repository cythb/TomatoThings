//
//  Task+CoreDataProperties.swift
//  
//
//  Created by tanghaibo on 16/2/3.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var createTime: NSDate?
    @NSManaged var estimateNUMT: NSNumber?
    @NSManaged var actualNUMT: NSNumber?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var addition: String?

}
