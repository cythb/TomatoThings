//
//  Category.swift
//  
//
//  Created by tanghaibo on 16/2/15.
//
//

import Foundation
import CoreData


class Category: NSManagedObject, NSCoding {

// Insert code here to add functionality to your managed object subclass
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(entity: NSEntityDescription(coder: aDecoder)!, insertIntoManagedObjectContext: nil)
        
        name = aDecoder.decodeObjectForKey("name") as? String
        index = Int16(aDecoder.decodeIntForKey("index"))
        
        if let data = aDecoder.decodeObjectForKey("tasks") as? NSData {
            tasks = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSSet
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(Int(index), forKey: "index")

        if let tasks = self.tasks {
            let data = NSKeyedArchiver.archivedDataWithRootObject(tasks)
            aCoder.encodeObject(data, forKey: "tasks")
        }
    }
}
