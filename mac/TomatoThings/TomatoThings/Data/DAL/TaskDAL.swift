//
//  TaskDAL.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Foundation

class TaskDAL: NSObject {
  static let gShared = TaskDAL()
  
  static func shared() -> TaskDAL {
    return gShared
  }
  
  func nextIndexForTask() -> Int64 {
    var index = UserDefaults.standard.integer(forKey: "task.index")
    index += 1
    UserDefaults.standard.set(index, forKey: "task.index")
    return Int64(index)
  }
    
    func nextCompleteIndexForTask() -> Int64 {
        var index = UserDefaults.standard.integer(forKey: "task.index")
        index += 1
        index += 10000
        return Int64(index)
    }
  
  /**
  添加任务
  
  @NSManaged var createTime: NSDate?
  
  @NSManaged var estimateNUMT: NSNumber?
  
  @NSManaged var actualNUMT: NSNumber?
  
  @NSManaged var title: String?
  
  暂时只用这4个字段，其他的做为以后的扩展使用
  
  - parameter title: 任务的标题
  - parameter eNUMT: 预计需要多少个番茄才能完成任务
  
  - returns: 创建成果的Task对象
  */
  func addTask(_ title: String, eNUMT: Int16) -> Task? {
    let task = CoreDataHelper.createEntity("Task") as! Task
    task.title = title
    task.estimateNUMT = eNUMT
    
    task.index = nextIndexForTask()
    return task
  }
  
  /**
  删除任务
  
  - parameter task: 需要被删除的任务
  
  - returns: 成功返回true，否则返回false
  */
  func removeTask(_ task: Task) {
    CoreDataHelper.removeEntity(task)
  }
}
