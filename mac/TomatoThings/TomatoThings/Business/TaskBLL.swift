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
}
