//
//  TaskBLL.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TaskBLL: NSObject {
  static let gShared = TaskBLL()
  
  static func shared() -> TaskBLL {
    return gShared
  }
  
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
    return task
  }
  
  /**
   开始计时
   
   - parameter task: 针对的任务
   */
  func start(task: Task) {
    
  }
  
  /**
   结束计时
   
   - parameter task: 针对的任务
   */
  func stop(task: Task) {
    
  }
}
