//
//  TakeARestViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/5.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TakeARestViewController: NSViewController {
  var task: Task!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "休息一下:]"
  }
 
  // MARK: - actions
  @IBAction func onContinueBtnClicked(sender: AnyObject) {
    self.dismissController(self)
    
    // 继续干一个番茄
    TaskBLL.shared().start(task)
  }
  
  @IBAction func onRestBtnClicked(sender: AnyObject) {
    // TODO: 所有按钮不可用
    // TODO: 休息一下
    // 4 5 10 20 
  }
  @IBAction func onFinishBtnClicked(sender: AnyObject) {
    guard task != nil else {
      return
    }
    
    TaskBLL.shared().finish(task)
  }
}
