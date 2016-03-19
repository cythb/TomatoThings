//
//  TaskLog.swift
//
//
//  Created by tanghaibo on 16/2/4.
//
//

import Foundation
import CoreData

/*
@NSManaged var startDate: NSTimeInterval
@NSManaged var endDate: NSTimeInterval
@NSManaged var task: Task?
*/
class TaskLog: NSManagedObject, NSCoding {
    
    class func taskLog(task: Task) -> TaskLog {
        let taskLog = CoreDataHelper.createEntity("TaskLog") as! TaskLog
        taskLog.task = task
        taskLog.startDate = NSDate().timeIntervalSince1970
        
        return taskLog
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(startDate, forKey: "startDate")
        aCoder.encodeDouble(endDate, forKey: "endDate")
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(entity: NSEntityDescription(coder: aDecoder)!, insertIntoManagedObjectContext: nil)
        
        startDate = aDecoder.decodeDoubleForKey("startDate")
        endDate = aDecoder.decodeDoubleForKey("endDate")
    }
}
