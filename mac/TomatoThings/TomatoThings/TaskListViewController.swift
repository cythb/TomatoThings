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
      guard let text: String = textField.stringValue else {
        return false
      }
      guard text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
        return false
      }
      
      let task = TaskBLL.shared().addTask(text, eNUMT: 1)
      arrayController.addObject(task!)
      
      return true
    }
    
    return retval;
  }
}
