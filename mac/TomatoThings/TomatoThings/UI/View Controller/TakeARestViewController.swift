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
    
    TaskBLL.shared().taskSignal.observeNext {[unowned self] (task, type) -> () in
      switch type {
      case .StartRest:
        self.enabelButtons(self.view, enable: false)
      case .EndRest:
        self.enabelButtons(self.view, enable: true)
        self.dismissController(self)
        break
      default:
        break
      }
        
    }
  }
 
  // MARK: - actions
  @IBAction func onContinueBtnClicked(sender: AnyObject) {
    self.dismissController(self)
    
    // 继续干一个番茄
    TaskBLL.shared().startTomato(task)
  }
  
  private func enabelButtons(inview: NSView, enable: Bool) {
    for subview in inview.subviews {
      if let btn = subview as? NSButton {
        btn.enabled = enable
      }else {
        self.enabelButtons(subview, enable: enable)
      }
    }
  }
  
  @IBAction func onRestBtnClicked(sender: AnyObject) {
    TaskBLL.shared().startRest(task)
  }
  @IBAction func onFinishBtnClicked(sender: AnyObject) {
    self.dismissController(self)
    
    TaskBLL.shared().finishTask(task)
  }
}
