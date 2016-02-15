//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var name: String?
    @NSManaged var index: Int16
    @NSManaged var tasks: NSSet?

}
