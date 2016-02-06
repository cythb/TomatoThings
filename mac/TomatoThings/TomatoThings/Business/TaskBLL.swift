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
  private var currentRestLog: RestLog?
  private var currentTaskLog: TaskLog?
  
  let progressingTask = MutableProperty<Task?>(nil)
  let remainTimeText = MutableProperty<String>("25:00")
  let (taskSignal, taskObserver) = Signal<Int, NoError>.pipe()
  
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
    return task
  }
  
  // MARK: Task
  /**
   开始计时
   
   - parameter task: 针对的任务
   */
  func startTask(task: Task) {
    guard nil == timer else {
      return
    }
    
    progressingTask.value = task
    
    startDate = NSDate()
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerFire:", userInfo: nil, repeats: true)
    
    currentTaskLog = TaskLog.taskLog(task)
  }
  
  /**
   结束计时
   
   - parameter task: 针对的任务
   */
  func stopTask(finish: Bool = false) {
    guard let task = progressingTask.value else {
      return
    }
    guard let taskLog = currentTaskLog else {
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
    
    // log
    taskLog.endDate = NSDate().timeIntervalSince1970
    currentTaskLog = nil
  }
  
  /**
   完成任务
   
   - parameter task: task
   */
  func finishTask(task: Task) {
    guard let taskLog = currentTaskLog else {
      return
    }
    
    task.finishDate = NSDate().timeIntervalSince1970
    
    // log
    taskLog.endDate = NSDate().timeIntervalSince1970
    currentTaskLog = nil
  }
  
  // MARK: - Rest
  // 开始休息
  func startRest(task: Task) {
    let restLog = RestLog(aTask: task)
    restLog.startDate = NSDate().timeIntervalSince1970
    restLog.fixedDuration = 5 * 60
    
    currentRestLog = restLog
  }
  
  // 结束休息
  func endRest() {
    guard let restLog = currentRestLog else {
      return
    }
    
    restLog.endDate = NSDate().timeIntervalSince1970
    currentRestLog = nil
  }
  
  // MARK: - actions
  func onTimerFire(sender: NSTimer) {
    let date = NSDate()
    let diffTimeInterval = duration - (date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
    guard diffTimeInterval > 0 else {
      self.stopTask(true)
      taskObserver.sendNext(1)
      return
    }
    
    let diffDate = NSDate(timeIntervalSince1970: diffTimeInterval)
    remainTimeText.value = timeFormater.stringFromDate(diffDate)
  }
}
