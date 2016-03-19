//
//  RestLog.swift
//
//
//  Created by tanghaibo on 16/2/6.
//
//

import Foundation
import CoreData


class RestLog: NSManagedObject {
    
    convenience init(aTask: Task) {
        let entity = NSEntityDescription.entityForName("RestLog", inManagedObjectContext: CoreDataHelper.managedObjectContext)
        self.init(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.managedObjectContext)
        
        self.task = aTask
    }
    
}
