//
//  CoreDataHelper.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class CoreDataHelper: NSObject {
  static var managedObjectContext = (NSApp.delegate as! AppDelegate).managedObjectContext
  
  /**
   添加条目
   
   - parameter name: 需要添加条目的名字
   
   - returns: 成功创建的条目，或者nil
   */
  static func createEntity(_ name: String) -> NSManagedObject {
    let enety = NSEntityDescription.insertNewObject(forEntityName: name, into: managedObjectContext)
    return enety
  }
  
  /**
   删除条目
   
   - parameter task: 被删除的条目
   */
  static func removeEntity(_ task: Task) {
    managedObjectContext.delete(task)
  }
}
