//
//  TaskListViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class TaskListViewController: NSViewController, NSTextFieldDelegate, NSTableViewDataSource {
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
    var secondActionNameTransformer: TaskActionSecondNameTransformer = {
        let transformer = TaskActionSecondNameTransformer()
        NSValueTransformer.setValueTransformer(transformer, forName: "TaskActionSecondNameTransformer")
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
                
                let taskList = self?.arrayController.arrangedObjects as! [Task]
                taskList.first?.index = TaskDAL.shared().nextIndexForTask()
                self?.arrayController.rearrangeObjects()
                self?.tableView.moveRowAtIndex(0, toIndex: taskList.count - 1)
                
            case .EndRest:
                self?.tableView.reloadData()
            default:
                break
            }
        }
        
        tableView.registerForDraggedTypes(["public.data"])
    }
    
    // MARK: - NSTextFieldDelegate
    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        var retval = false
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
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
    
    // MARK: - NSTableViewDataSource
    func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(rowIndexes)
        pboard .declareTypes([NSStringPboardType], owner: self)
        pboard.setData(data, forType: NSStringPboardType)
        return true
    }
    
    func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        if dropOperation == .Above {
            return .Move
        }
        return .None
    }
    
    func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        guard let data = info.draggingPasteboard().dataForType(NSStringPboardType) else {
            return false
        }
        
        guard let rowIndexes = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSIndexSet  else {
            return false
        }
        
        guard rowIndexes.firstIndex != NSNotFound else {
            return false
        }
        
        // rowIndexes.firstIndex ..< row
        var orders = [Int64]()
        if rowIndexes.firstIndex < row {
            for index in rowIndexes.firstIndex ..< row {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        orders.append(arrangedObjects[index].index)
                    }
                }
            }
        } else {
            for index in row ... rowIndexes.lastIndex  {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        orders.append(arrangedObjects[index].index)
                    }
                }
            }
        }
        orders.sortInPlace()
        
        var arrangedTasks = [Task]()
        if rowIndexes.lastIndex+1 < row {
            for index in rowIndexes.lastIndex+1 ..< row {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
            for index in rowIndexes.firstIndex ... rowIndexes.lastIndex {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
        } else if row < rowIndexes.firstIndex {
            for index in rowIndexes.firstIndex ... rowIndexes.lastIndex {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
            for index in row ..< rowIndexes.firstIndex {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
        } else {
            return false
        }
        
        
        for index in 0 ..< arrangedTasks.count {
            let t = arrangedTasks[index]
            var i: Int64? = nil
            if index < orders.count {
                i = orders[index]
            }
            if let taskIndex = i {
                t.index = taskIndex
            }
        }
        
        arrayController.rearrangeObjects()
        return true
    }
    
    // MARK: - Actions
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
    
    @IBAction func onSecondBtnClicked(sender: NSButton) {
        let row = tableView.rowForView(sender)
        let cell = tableView.viewAtColumn(2, row: row, makeIfNecessary: true) as! NSTableCellView
        guard let task = cell.objectValue as? Task else {
            return
        }
        
        if TaskBLL.shared().progressingTask.value == task {
            //完成
            TaskBLL.shared().finishTask(task)
        } else {
            //删除
            TaskDAL.shared().removeTask(task)
            arrayController.removeObject(task)
        }
    }
}
