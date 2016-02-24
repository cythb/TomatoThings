//
//  Task.swift
//  
//
//  Created by tanghaibo on 16/2/4.
//
//

import Foundation
import CoreData


class Task: NSManagedObject, NSCoding {

// Insert code here to add functionality to your managed object subclass
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(addition, forKey: "addition")
        aCoder.encodeObject(Int(completeTomatos), forKey: "completeTomatos")
        aCoder.encodeObject(content, forKey: "content")
        aCoder.encodeObject(Double(createTime), forKey: "createTime")
        aCoder.encodeObject(Int(estimateNUMT), forKey: "estimateNUMT")
        aCoder.encodeObject(Double(finishDate), forKey: "finishDate")
        aCoder.encodeObject(Int(finished), forKey: "finished")
        aCoder.encodeObject(Int(incompleteTomatos), forKey: "incompleteTomatos")
        aCoder.encodeObject(Int(index), forKey: "index")
        aCoder.encodeObject(title, forKey: "title")
        
        if let logs = self.logs {
            let logsData = NSKeyedArchiver.archivedDataWithRootObject(logs)
            aCoder.encodeObject(logsData, forKey: "logs")
        }
        
        if let restLogs = self.restLogs {
            let data = NSKeyedArchiver.archivedDataWithRootObject(restLogs)
            aCoder.encodeObject(data, forKey: "restLogs")
        }
        
        if let category = self.category {
            let data = NSKeyedArchiver.archivedDataWithRootObject(category)
            aCoder.encodeObject(data, forKey: "category")
        }
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(entity: NSEntityDescription(coder: aDecoder)!, insertIntoManagedObjectContext: nil)
      
        addition = aDecoder.decodeObjectForKey("addition") as? String
        completeTomatos = Int16(aDecoder.decodeInt32ForKey("completeTomatos"))
        content = aDecoder.decodeObjectForKey("content") as? String
        createTime = aDecoder.decodeDoubleForKey("createTime")
        estimateNUMT = Int16(aDecoder.decodeInt32ForKey("estimateNUMT"))
        finishDate = aDecoder.decodeDoubleForKey("finishDate")
        incompleteTomatos = Int16(aDecoder.decodeInt32ForKey("incompleteTomatos"))
        index = aDecoder.decodeInt64ForKey("index")
        title = aDecoder.decodeObjectForKey("title") as? String
        
        if let logsData = aDecoder.decodeObjectForKey("logs") as? NSData {
            logs = NSKeyedUnarchiver.unarchiveObjectWithData(logsData) as? NSSet
        }
        
        if let restLogsData = aDecoder.decodeObjectForKey("restLogs") as? NSData {
            restLogs = NSKeyedUnarchiver.unarchiveObjectWithData(restLogsData) as? NSSet
        }
        
        if let categoryData = aDecoder.decodeObjectForKey("category") as? NSData {
            category = NSKeyedUnarchiver.unarchiveObjectWithData(categoryData) as? NSManagedObject
        }
    }
}
