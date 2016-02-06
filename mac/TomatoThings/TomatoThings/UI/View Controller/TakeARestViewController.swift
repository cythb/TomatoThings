//
//  TakeARestViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/5.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TakeARestViewController: NSViewController {
  var task: Task
  
  init?(task: Task) {
    self.task = task
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "休息一下:]"
  }
 
  // MARK: - actions
  @IBAction func onContinueBtnClicked(sender: AnyObject) {
    self.dismissController(self)
    
    // 继续干一个番茄
    TaskBLL.shared().startTomato(task)
  }
  
  @IBAction func onRestBtnClicked(sender: AnyObject) {
    // TODO: 所有按钮不可用
    // TODO: 休息一下
    // 4 5 10 20 
  }
  @IBAction func onFinishBtnClicked(sender: AnyObject) {
    self.dismissController(self)
    
    TaskBLL.shared().finishTask(task)
  }
}
