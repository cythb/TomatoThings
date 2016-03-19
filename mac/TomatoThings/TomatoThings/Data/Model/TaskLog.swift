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
class TaskLog: NSManagedObject {
    
    class func taskLog(task: Task) -> TaskLog {
        let taskLog = CoreDataHelper.createEntity("TaskLog") as! TaskLog
        taskLog.task = task
        taskLog.startDate = NSDate().timeIntervalSince1970
        
        return taskLog
    }
}
