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
      return "\(task!.actualNUMT!.integerValue)/\(task!.estimateNUMT!.integerValue)"
    }
  }
}

class TaskActionEnableTransformer: NSValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return Task.self
  }
  
  override func transformedValue(value: AnyObject?) -> AnyObject? {
    return true
  }
}
