//
//  TaskListViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TaskListViewController: NSViewController, NSTextFieldDelegate {
  @IBOutlet var arrayController: NSArrayController!
  
  var tnumTransformer: TaskCellTransformer = {
    let transformer = TaskCellTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskCellTransformer")
    return transformer
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - NSTextFieldDelegate
  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    var retval = false
    if commandSelector == "insertNewline:" {
      retval = true
      
      guard let textField = control as? NSTextField else {
        return false
      }
      guard var text: String = textField.stringValue else {
        return false
      }
      guard text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
        return false
      }
      
      // 处理空格
      while text.containsString("  ") {
        text = text.stringByReplacingOccurrencesOfString("  ", withString: " ")
      }
      
      // 解析数据
      let (taskTitle, taskETNUM) = parseInputString(text)
      
      guard let title = taskTitle else {
        return false
      }
      
      let task = TaskBLL.shared().addTask(title, eNUMT: Int16(taskETNUM) )
      arrayController.addObject(task!)
      
      return true
    }
    
    return retval;
  }
  
  func parseInputString(text: String) -> (title: String?, eNumT: Int) {
    // this is a title -e 3
    // -t this is a title -e 3
    // -e 3 this is a title
    // -e 3 -t this is a title
    let components = text.componentsSeparatedByString(" ")
    var taskTitle: String?
    var taskETNUM: Int! = 1
    for var i = 0; i < components.count; i++ {
      defer {
        print(i)
      }
      
      var cmd: String!
      var value: String!
      var first: String!
      var second: String?
      
      if i+1 < components.count {
        first = components[i]
        second = components[i+1]
      } else {
        first = components[i]
      }
      if first.hasPrefix("-t") || first.hasPrefix("-e") {
        cmd = first
        value = second
      } else {
        cmd = nil
        value = first
        taskTitle = value
        continue
      }
      
      if cmd == "-t" {
        guard value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
          continue
        }
        
        taskTitle = value
        
        i++
      }
      
      if cmd == "-e" {
        guard Int(value) != nil else {
          continue
        }
        
        taskETNUM = Int(value)!
        
        i++
      }
    }
    
    return (taskTitle, taskETNUM)
  }
}
