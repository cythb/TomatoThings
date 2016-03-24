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

enum TaskSignalType {
  case CompleteTask
  case StartTomato
  case EndTomato
  case DropTomato
  case StartRest
  case EndRest
}

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
  // 番茄信号：完成任务；开始番茄；完成番茄；
  let (taskSignal, taskObserver) = Signal<(Task, TaskSignalType), NoError>.pipe()
  
  func addTask(title: String, eNUMT: Int16) -> Task? {
    let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
    return task
  }
  
  private func startTimer() {
    startDate = NSDate()
    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TaskBLL.onTimerFire(_:)), userInfo: nil, repeats: true)
  }
  private func invalidateTimer() {
    timer.invalidate()
    startDate = nil
    remainTimeText.value = "25:00"
  }
  
  // MARK: Task
  /**
   开始计时
   
   - parameter task: 针对的任务
   */
  func startTomato(task: Task) {
    guard nil == timer else {
      return
    }
    
    progressingTask.value = task
    
    startTimer()
    
    currentTaskLog = TaskLog.taskLog(task)
    
    duration = 25 * 60
    
    taskObserver.sendNext((task, .StartTomato))
  }
  
  /**
   结束计时
   
   - parameter task: 针对的任务
   */
  func stopTomato(isEnd: Bool = false) {
    guard let task = progressingTask.value else {
      return
    }
    guard let taskLog = currentTaskLog else {
      return
    }
    
    if isEnd {
      taskObserver.sendNext((task, .EndTomato))
      task.completeTomatos = task.completeTomatos+1
      print("完成一个番茄")
    } else {
      print("放弃一个番茄")
      taskObserver.sendNext((task, .DropTomato))
      task.incompleteTomatos = task.incompleteTomatos+1
    }
    
    // log
    taskLog.endDate = NSDate().timeIntervalSince1970
    currentTaskLog = nil
    
    // 收尾工作
    progressingTask.value = nil
    
    invalidateTimer()
  }
  
  /**
   完成任务
   
   - parameter task: task
   */
  func finishTask(task: Task) {
    task.finishDate = NSDate().timeIntervalSince1970
    task.finished = true
    
    taskObserver.sendNext((task, .CompleteTask))
    print("完成一个任务")
  }
  
  // MARK: - Rest
  func restTimeKey() -> String {
    let df = NSDateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let todayKey = df.stringFromDate(NSDate())
    return todayKey
  }
  
  func resetRestTimes() {
    let times = NSUserDefaults.standardUserDefaults().integerForKey(restTimeKey())
    if times > 0 {
      setRestTimes(0)
    }
  }
  
  func restTimes() -> Int {
    let times = NSUserDefaults.standardUserDefaults().integerForKey(restTimeKey())
    return times
  }
  
  func setRestTimes(times: Int) {
    NSUserDefaults.standardUserDefaults().setInteger(times, forKey: restTimeKey())
  }
  
  // 开始休息
  func startRest(task: Task) {
    let restLog = RestLog(aTask: task)
    restLog.startDate = NSDate().timeIntervalSince1970
  
    let currentRestTimes = restTimes() + 1
    setRestTimes(currentRestTimes)
    if currentRestTimes == 0 || currentRestTimes%4 != 0 {
      restLog.fixedDuration = 5 * 60
    }else {
      restLog.fixedDuration = 20 * 60
    }
    
    currentRestLog = restLog
    
    duration = restLog.fixedDuration
    
    taskObserver.sendNext((task, .StartRest))
    
    startTimer()
  }
  
  // 结束休息
  func endRest(restLog: RestLog) {
    restLog.endDate = NSDate().timeIntervalSince1970
    currentRestLog = nil
    
    taskObserver.sendNext((restLog.task!, .EndRest))
    
    invalidateTimer()
  }
  
  // MARK: - actions
  func onTimerFire(sender: NSTimer) {
    let date = NSDate()
    let diffTimeInterval = duration - (date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
    guard diffTimeInterval > 0 else {
      if let restLog = currentRestLog {
        self.endRest(restLog)
      } else {
        self.stopTomato(true)
      }
      return
    }
    
    let diffDate = NSDate(timeIntervalSince1970: diffTimeInterval)
    remainTimeText.value = timeFormater.stringFromDate(diffDate)
  }
}
