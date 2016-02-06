//
//  TaskCellTransformer.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TaskCellTransformer: NSValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return Task.self
  }

  override func transformedValue(value: AnyObject?) -> AnyObject? {
    let task = value as? Task
    if task === nil {
      return "NAN"
    } else {
      return "\(task!.completeTomatos)/\(task!.estimateNUMT)"
    }
  }
}

class TaskActionEnableTransformer: NSValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return Task.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    guard let task = value as? Task else {
      return false
    }
    guard nil != TaskBLL.shared().progressingTask.value else {
      return true
    }
    
    return task == TaskBLL.shared().progressingTask.value
  }
}

class TaskActionNameTransformer: NSValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return Task.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    guard let task = value as? Task else {
      return "开始"
    }
    guard nil != TaskBLL.shared().progressingTask.value else {
      return "开始"
    }
    
    if task == TaskBLL.shared().progressingTask.value {
      return "放弃"
    }else {
      return "开始"
    }
  }
}
