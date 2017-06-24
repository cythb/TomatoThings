
//
//  TaskListViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveSwift

class TaskListViewController: NSViewController, NSTextFieldDelegate, NSTableViewDataSource {
    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    
    var tnumTransformer: TaskCellTransformer = {
        let transformer = TaskCellTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskCellTransformer"))
        return transformer
    }()
    var actionEnableTransformer: TaskActionEnableTransformer = {
        let transformer = TaskActionEnableTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskActionEnableTransformer"))
        return transformer
    }()
    var actionNameTransformer: TaskActionNameTransformer = {
        let transformer = TaskActionNameTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskActionNameTransformer"))
        return transformer
    }()
    var secondActionNameTransformer: TaskActionSecondNameTransformer = {
        let transformer = TaskActionSecondNameTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskActionSecondNameTransformer"))
        return transformer
    }()
    var colorForNUMTransformer: TaskCellNUMTColorTransformer = {
        let transformer = TaskCellNUMTColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskCellNUMTColorTransformer"))
        return transformer
    }()
    var titleTransformer: TaskTitleTransformer = {
        let transformer = TaskTitleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "TaskTitleTransformer"))
        return transformer
    }()
    var sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskBLL.shared().taskSignal.observeValues { [weak self](value) -> () in
            
            let task = value.0
            
            switch value.1 {
            case .startTomato:
                self?.tableView.reloadData()
                
                break
            case .endTomato:
                self?.tableView.reloadData()
                
                // 弹出视图：休息／继续
                let restVC = TakeARestViewController(task: task)!
                self?.presentViewControllerAsSheet(restVC)
            case .dropTomato:
                self?.tableView.reloadData()
                
                break
            case .completeTask:
                let taskList = self?.arrayController.arrangedObjects as! [Task]
                if let index = taskList.index(of: task) as Int! {
                    task.index = TaskDAL.shared().nextCompleteIndexForTask()
                    self?.arrayController.rearrangeObjects()
                    self?.tableView.moveRow(at: index, to: taskList.count - 1)
                }
            case .endRest:
                self?.tableView.reloadData()
            default:
                break
            }
        }
        
        tableView.register(forDraggedTypes: ["public.data"])
    }
    
    // MARK: - NSTextFieldDelegate
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        var retval = false
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            retval = true
            
            guard let textField = control as? NSTextField else {
                return false
            }
            guard textField.stringValue.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
                return false
            }
            
            var text = textField.stringValue;
            
            // 处理空格
            while text.contains("  ") {
                text = text.replacingOccurrences(of: "  ", with: " ")
            }
            
            // 解析数据
            let (taskTitle, taskETNUM) = parseInputString(text)
            
            guard let title = taskTitle else {
                return false
            }
            
            let task = TaskBLL.shared().addTask(title, eNUMT: Int16(taskETNUM) )
            arrayController.addObject(task!)
            arrayController.rearrangeObjects()
            
            return true
        }
        
        return retval;
    }
    
    func parseInputString(_ text: String) -> (title: String?, eNumT: Int) {
        // this is a title -e 3
        var taskTitle: String? = nil
        var taskETNUM: Int! = 1
        var range = text.range(of: " -")
        
        if nil != range {
            taskTitle = text.substring(to: range!.lowerBound).trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        while range != nil && range!.lowerBound != range!.upperBound {
            let temp = text.substring(from: range!.lowerBound).trimmingCharacters(in: CharacterSet.whitespaces)
            let components = temp.components(separatedBy: " ")
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
            
            range = text.range(of: " -", options: .literal, range: (range!.upperBound ..< text.endIndex), locale: nil)
        }
        
        if taskTitle == nil || taskTitle == ""{
            taskTitle = text
        }
        
        return (taskTitle, taskETNUM)
    }
    
    // MARK: - NSTableViewDataSource
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        pboard .declareTypes([NSStringPboardType], owner: self)
        pboard.setData(data, forType: NSStringPboardType)
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        if dropOperation == .above {
            return .move
        }
        return NSDragOperation()
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        guard let data = info.draggingPasteboard().data(forType: NSStringPboardType) else {
            return false
        }
        
        guard let rowIndexes = NSKeyedUnarchiver.unarchiveObject(with: data) as? IndexSet  else {
            return false
        }
        
        guard rowIndexes.first != NSNotFound else {
            return false
        }
        
        // rowIndexes.firstIndex ..< row
        var orders = [Int64]()
        if rowIndexes.first! < row {
            for index in rowIndexes.first! ..< row {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        orders.append(arrangedObjects[index].index)
                    }
                }
            }
        } else {
            for index in row ... rowIndexes.last!  {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        orders.append(arrangedObjects[index].index)
                    }
                }
            }
        }
        orders.sort()
        
        var arrangedTasks = [Task]()
        if rowIndexes.last!+1 < row {
            for index in rowIndexes.last!+1 ..< row {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
            for index in rowIndexes.first! ... rowIndexes.last! {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
        } else if row < rowIndexes.first! {
            for index in rowIndexes.first! ... rowIndexes.last! {
                if let arrangedObjects = arrayController.arrangedObjects as? [Task] {
                    if index < arrangedObjects.count {
                        arrangedTasks.append(arrangedObjects[index])
                    }
                }
            }
            for index in row ..< rowIndexes.first! {
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
    @IBAction func onStartBtnClicked(_ sender: NSButton) {
        let row = tableView.row(for: sender)
        let cell = tableView.view(atColumn: 2, row: row, makeIfNecessary: true) as! NSTableCellView
        guard let task = cell.objectValue as? Task else {
            return
        }
        
        if nil == TaskBLL.shared().progressingTask.value {
            TaskBLL.shared().startTomato(task)
        }else if TaskBLL.shared().progressingTask.value == task {
            TaskBLL.shared().stopTomato()
        }
    }
    
    @IBAction func onSecondBtnClicked(_ sender: NSButton) {
        let row = tableView.row(for: sender)
        let cell = tableView.view(atColumn: 2, row: row, makeIfNecessary: true) as! NSTableCellView
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
