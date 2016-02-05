//
//  TaskBLL.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class TaskBLL: NSObject {
  static let gShared = TaskBLL()
  
  static func shared() -> TaskBLL {
    return gShared
  }
  
  private weak var timer: NSTimer!
  private var startDate: NSDate!
  private lazy var timeFormater: NSDateFormatter = {
    let f = NSDateFormatter()
    f.dateFormat = "mm:ss"
    return f
  }()
  var progressingTask = MutableProperty<Task?>(nil)
  
  let remainTimeText = MutableProperty<String>("25:00")
  
  override init() {
  }
  
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
    return task
  }
  
  /**
   开始计时
   
   - parameter task: 针对的任务
   */
  func start(task: Task) {
    guard nil == timer else {
      return
    }
    
    progressingTask.value = task
    
    startDate = NSDate()
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerFire:", userInfo: nil, repeats: true)
  }
  
  /**
   结束计时
   
   - parameter task: 针对的任务
   */
  func stop() {
    timer.invalidate()
    startDate = nil
    progressingTask.value = nil
    remainTimeText.value = "25:00"
  }
  
  // MARK: actions
  func onTimerFire(sender: NSTimer) {
    let date = NSDate()
    let diffTimeInterval = 25 * 60 - (date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
    guard diffTimeInterval > 0 else {
      print("一个番茄结束")
      self.stop()
      return
    }
    
    let diffDate = NSDate(timeIntervalSince1970: diffTimeInterval)
    remainTimeText.value = timeFormater.stringFromDate(diffDate)
  }
}
