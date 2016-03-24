//
//  TaskCellTransformer.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

// MARK: - 番茄数列
class TaskCellTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        let task = value as? Task
        if task === nil {
            return "NAN"
        } else {
            var str = "\(task!.completeTomatos)/\(task!.estimateNUMT)"
            if task!.incompleteTomatos > 0 {
                str += "(\(task!.incompleteTomatos))"
            }
            return str
        }
    }
}

class TaskCellNUMTColorTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let task = value as? Task else {
            return NSColor.blackColor()
        }
        
        if task.completeTomatos > task.estimateNUMT {
            return NSColor.redColor()
        }else {
            return NSColor.blackColor()
        }
    }
}

// MARK: - 动作列
class TaskActionEnableTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let task = value as? Task else {
            return false
        }
        guard !task.finished else {
            return false
        }
        guard nil != TaskBLL.shared().progressingTask.value else {
            return true
        }
        
        return task == TaskBLL.shared().progressingTask.value
    }
}

///  transformer for title of the first button
class TaskActionNameTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let task = value as? Task else {
            return "开始"
        }
        guard !task.finished else {
            return "已完成"
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

///  transformer for title of the second button
class TaskActionSecondNameTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let task = value as? Task else {
            return "删除"
        }
        
        if task == TaskBLL.shared().progressingTask.value {
            return "完成"
        }else {
            return "删除"
        }
    }
}

class TaskTitleTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return Task.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let task = value as? Task else {
            return ""
        }
        
        let str = NSMutableAttributedString(string: task.title!)
        if task.finished {
            str.addAttribute(NSStrikethroughStyleAttributeName, value: true, range: NSMakeRange(0, str.length))
        }
        
        return str
    }
}
