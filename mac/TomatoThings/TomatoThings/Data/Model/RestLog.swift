//
//  RestLog.swift
//
//
//  Created by tanghaibo on 16/2/6.
//
//

import Foundation
import CoreData


class RestLog: NSManagedObject, NSCoding {
    
    convenience init(aTask: Task) {
        let entity = NSEntityDescription.entityForName("RestLog", inManagedObjectContext: CoreDataHelper.managedObjectContext)
        self.init(entity: entity!, insertIntoManagedObjectContext: CoreDataHelper.managedObjectContext)
        
        self.task = aTask
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(entity: NSEntityDescription(coder: aDecoder)!, insertIntoManagedObjectContext: nil)
        
        endDate = aDecoder.decodeDoubleForKey("endDate")
        fixedDuration = aDecoder.decodeDoubleForKey("fixedDuration")
        startDate = aDecoder.decodeDoubleForKey("startDate")
        
        if let data = aDecoder.decodeObjectForKey("task") as? NSData {
            task = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Task
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(Double(endDate), forKey: "endDate")
        aCoder.encodeObject(Double(fixedDuration), forKey: "fixedDuration")
        aCoder.encodeObject(Double(startDate), forKey: "startDate")
        
        if let task = self.task {
            let data = NSKeyedArchiver.archivedDataWithRootObject(task)
            aCoder.encodeObject(data, forKey: "task")
        }
    }
    
}
