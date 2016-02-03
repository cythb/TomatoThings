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
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = CoreDataHelper.createEntity("Task") as! Task
    task.title = title
    task.estimateNUMT = NSNumber(int: Int32(eNUMT) )
    return task
  }
  
  /**
  删除任务
  
  - parameter task: 需要被删除的任务
  
  - returns: 成功返回true，否则返回false
  */
  func removeTask(task: Task) {
    CoreDataHelper.removeEntity(task)
  }
}
