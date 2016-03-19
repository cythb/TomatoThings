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
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(Double(endDate), forKey: "endDate")
        aCoder.encodeObject(Double(fixedDuration), forKey: "fixedDuration")
        aCoder.encodeObject(Double(startDate), forKey: "startDate")
    }
    
}
