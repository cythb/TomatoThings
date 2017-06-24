//
//  TaskBLL.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveSwift
import Result

enum TaskSignalType {
    case completeTask
    case startTomato
    case endTomato
    case dropTomato
    case startRest
    case endRest
}

class TaskBLL: NSObject {
    static let gShared = TaskBLL()
    
    static func shared() -> TaskBLL {
        return gShared
    }
    
    fileprivate weak var timer: Timer!
    fileprivate var startDate: Date!
    fileprivate lazy var timeFormater: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "mm:ss"
        return f
    }()
    fileprivate var duration: TimeInterval = 25 * 60 //阶段需要的时间
    fileprivate var currentRestLog: RestLog?
    fileprivate var currentTaskLog: TaskLog?
    
    let progressingTask = MutableProperty<Task?>(nil)
    let remainTimeText = MutableProperty<String>("25:00")
    // 番茄信号：完成任务；开始番茄；完成番茄；
    let (taskSignal, taskObserver) = Signal<(Task, TaskSignalType), NoError>.pipe()
    
    func addTask(_ title: String, eNUMT: Int16) -> Task? {
        let task = TaskDAL.shared().addTask(title, eNUMT: eNUMT)
        return task
    }
    
    fileprivate func startTimer() {
        startDate = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TaskBLL.onTimerFire(_:)), userInfo: nil, repeats: true)
    }
    fileprivate func invalidateTimer() {
        timer.invalidate()
        startDate = nil
        remainTimeText.value = "25:00"
    }
    
    // MARK: Task
    /**
     开始计时
     
     - parameter task: 针对的任务
     */
    func startTomato(_ task: Task) {
        guard nil == timer else {
            return
        }
        
        progressingTask.value = task
        
        startTimer()
        
        currentTaskLog = TaskLog.taskLog(task)
        
        duration = 25 * 60
        
        taskObserver.send(value: (task, .startTomato))
    }
    
    /**
     结束计时
     
     - parameter task: 针对的任务
     */
    func stopTomato(_ isEnd: Bool = false) {
        guard let task = progressingTask.value else {
            return
        }
        guard let taskLog = currentTaskLog else {
            return
        }
        
        if isEnd {
            taskObserver.send(value: (task, .endTomato))
            task.completeTomatos = task.completeTomatos+1
            print("完成一个番茄")
        } else {
            print("放弃一个番茄")
            taskObserver.send(value: (task, .dropTomato))
            task.incompleteTomatos = task.incompleteTomatos+1
        }
        
        // log
        taskLog.endDate = Date().timeIntervalSince1970
        currentTaskLog = nil
        
        // 收尾工作
        progressingTask.value = nil
        
        invalidateTimer()
    }
    
    /**
     完成任务
     
     - parameter task: task
     */
    func finishTask(_ task: Task) {
        task.finishDate = Date().timeIntervalSince1970
        task.finished = true
        
        if task == progressingTask.value {
            stopTomato(false)
        }
        
        taskObserver.send(value: (task, .completeTask))
        print("完成一个任务")
    }
    
    // MARK: - Rest
    func restTimeKey() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let todayKey = df.string(from: Date())
        return todayKey
    }
    
    func resetRestTimes() {
        let times = UserDefaults.standard.integer(forKey: restTimeKey())
        if times > 0 {
            setRestTimes(0)
        }
    }
    
    func restTimes() -> Int {
        let times = UserDefaults.standard.integer(forKey: restTimeKey())
        return times
    }
    
    func setRestTimes(_ times: Int) {
        UserDefaults.standard.set(times, forKey: restTimeKey())
    }
    
    // 开始休息
    func startRest(_ task: Task) {
        let restLog = RestLog(aTask: task)
        restLog.startDate = Date().timeIntervalSince1970
        
        let currentRestTimes = restTimes() + 1
        setRestTimes(currentRestTimes)
        if currentRestTimes == 0 || currentRestTimes%4 != 0 {
            restLog.fixedDuration = 5 * 60
        }else {
            restLog.fixedDuration = 20 * 60
        }
        
        currentRestLog = restLog
        
        duration = restLog.fixedDuration
        
        taskObserver.send(value: (task, .startRest))
        
        startTimer()
    }
    
    // 结束休息
    func endRest(_ restLog: RestLog) {
        restLog.endDate = Date().timeIntervalSince1970
        currentRestLog = nil
        
        taskObserver.send(value: (restLog.task!, .endRest))
        
        invalidateTimer()
    }
    
    // MARK: - actions
    func onTimerFire(_ sender: Timer) {
        let date = Date()
        let diffTimeInterval = duration - (date.timeIntervalSince1970 - startDate.timeIntervalSince1970)
        guard diffTimeInterval > 0 else {
            if let restLog = currentRestLog {
                self.endRest(restLog)
            } else {
                self.stopTomato(true)
            }
            return
        }
        
        let diffDate = Date(timeIntervalSince1970: diffTimeInterval)
        remainTimeText.value = timeFormater.string(from: diffDate)
    }
}
