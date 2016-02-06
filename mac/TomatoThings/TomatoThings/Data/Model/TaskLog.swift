//
//  TaskLog.swift
//  
//
//  Created by tanghaibo on 16/2/4.
//
//

import Foundation
import CoreData


class TaskLog: NSManagedObject {

  class func taskLog(task: Task) -> TaskLog {
    // search tasklog with task
    let fetchRequest = NSFetchRequest(entityName: "TaskLog")
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "task == %@", task)
    
    var taskLog: TaskLog!
    
    do {
      let taskLogs = try CoreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest) as! [TaskLog]
      taskLog = taskLogs.first
    } catch {
    }
    
    if nil == taskLog {
      taskLog = CoreDataHelper.createEntity("TaskLog") as! TaskLog
      taskLog.task = task
      taskLog.startDate = NSDate().timeIntervalSince1970
    }
    
    return taskLog
  }

}
