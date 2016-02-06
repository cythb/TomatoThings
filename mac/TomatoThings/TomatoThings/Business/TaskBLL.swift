//
//  TaskBLL.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Result

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
  private var duration: NSTimeInterval = 25 * 60 //阶段需要的时间
  
  let progressingTask = MutableProperty<Task?>(nil)
  let remainTimeText = MutableProperty<String>("25:00")
  let (taskSignal, taskObserver) = Signal<Int, NoError>.pipe()
  
  override init() {
  }
  
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
    return task
  }
  
  // MARK: Task
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
    
    TaskLog.taskLog(task)
  }
  
  /**
   结束计时
   
   - parameter task: 针对的任务
   */
  func stop(finish: Bool = false) {
    guard let task = progressingTask.value else {
      return
    }
    
    timer.invalidate()
    startDate = nil
    progressingTask.value = nil
    remainTimeText.value = "25:00"
    
    if finish {
      task.completeTomatos = task.completeTomatos+1
      print("一个番茄结束")
    } else {
      task.incompleteTomatos = task.incompleteTomatos+1
    }
  }
  
  /**
   完成任务
   
   - parameter task: task
   */
  func finish(task: Task) {
    let log = TaskLog.taskLog(task)
    log.finishDate = NSDate().timeIntervalSince1970
  }
  
  // MARK: - Rest
  
  
  // MARK: - actions
  func onTimerFire(sender: NSTimer) {
    let date = NSDate()
    let diffTimeInterval = duration - (date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
    guard diffTimeInterval > 0 else {
      self.stop(true)
      taskObserver.sendNext(1)
      return
    }
    
    let diffDate = NSDate(timeIntervalSince1970: diffTimeInterval)
    remainTimeText.value = timeFormater.stringFromDate(diffDate)
  }
}
