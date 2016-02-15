//
//  Task.swift
//  
//
//  Created by tanghaibo on 16/2/4.
//
//

import Foundation
import CoreData


//@NSManaged var logs: NSSet?
//@NSManaged var restLogs: NSSet?
//@NSManaged var category: NSManagedObject?

class Task: NSManagedObject, NSCoding {

// Insert code here to add functionality to your managed object subclass
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.setValue(addition, forKey: "addition")
        aCoder.setValue(Int(completeTomatos), forKey: "completeTomatos")
        aCoder.setValue(content, forKey: "content")
        aCoder.setValue(Double(createTime), forKey: "createTime")
        aCoder.setValue(Int(estimateNUMT), forKey: "estimateNUMT")
        aCoder.setValue(Double(finishDate), forKey: "finishDate")
        aCoder.setValue(Int(finished), forKey: "finished")
        aCoder.setValue(Int(incompleteTomatos), forKey: "incompleteTomatos")
        aCoder.setValue(Int(index), forKey: "index")
        aCoder.setValue(title, forKey: "title")
        
        // logs
        // restlogs
        // category
    }
    
}
