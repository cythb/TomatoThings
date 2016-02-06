//
//  TaskListViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class TaskListViewController: NSViewController, NSTextFieldDelegate {
  @IBOutlet var arrayController: NSArrayController!
  @IBOutlet weak var tableView: NSTableView!
  
  var tnumTransformer: TaskCellTransformer = {
    let transformer = TaskCellTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskCellTransformer")
    return transformer
  }()
  var actionEnableTransformer: TaskActionEnableTransformer = {
    let transformer = TaskActionEnableTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskActionEnableTransformer")
    return transformer
  }()
  var actionNameTransformer: TaskActionNameTransformer = {
    let transformer = TaskActionNameTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskActionNameTransformer")
    return transformer
  }()
  var colorForNUMTransformer: TaskCellNUMTColorTransformer = {
    let transformer = TaskCellNUMTColorTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskCellNUMTColorTransformer")
    return transformer
  }()
  var titleTransformer: TaskTitleTransformer = {
    let transformer = TaskTitleTransformer()
    NSValueTransformer.setValueTransformer(transformer, forName: "TaskTitleTransformer")
    return transformer
  }()
  var sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
  
  override func viewDidLoad() { 
    super.viewDidLoad()
    
    TaskBLL.shared().taskSignal.observeNext { [weak self](value) -> () in
      
      let task = value.0
      
      switch value.1 {
      case .StartTomato:
        self?.tableView.reloadData()
        
        break
      case .EndTomato:
        self?.tableView.reloadData()
        
        // 弹出视图：休息／继续
        let restVC = TakeARestViewController(task: task)!
        self?.presentViewControllerAsSheet(restVC)
      case .DropTomato:
        self?.tableView.reloadData()
        
        break
      case .CompleteTask:
        self?.tableView.reloadData()
      case .EndRest:
        self?.tableView.reloadData()
      default:
        break
      }
    }
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
    var taskTitle: String? = nil
    var taskETNUM: Int! = 1
    var range = text.rangeOfString(" -")
    
    if nil != range {
      taskTitle = text.substringToIndex(range!.startIndex).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    while range != nil && range!.startIndex != range!.endIndex {
      let temp = text.substringFromIndex(range!.startIndex).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      let components = temp.componentsSeparatedByString(" ")
      guard components.count > 1 else {
        break
      }
      
      let cmd = components[0]
      var value = ""
      for i in 1..<components.count {
        if components[i] != "" {
          value = components[i]
          break
        }
      }
      
      if cmd == "-e" {
        taskETNUM = Int(value)
      }
      
      range = text.rangeOfString(" -", options: .LiteralSearch, range: Range<String.Index>(start: range!.endIndex, end: text.endIndex), locale: nil)
    }
    
    if taskTitle == nil || taskTitle == ""{
      taskTitle = text
    }
    
    return (taskTitle, taskETNUM)
  }
  
  @IBAction func onStartBtnClicked(sender: NSButton) {
    let row = tableView.rowForView(sender)
    let cell = tableView.viewAtColumn(2, row: row, makeIfNecessary: true) as! NSTableCellView
    guard let task = cell.objectValue as? Task else {
      return
    }
    
    if nil == TaskBLL.shared().progressingTask.value {
      TaskBLL.shared().startTomato(task)
    }else if TaskBLL.shared().progressingTask.value == task {
      TaskBLL.shared().stopTomato()
    }
  }
}
