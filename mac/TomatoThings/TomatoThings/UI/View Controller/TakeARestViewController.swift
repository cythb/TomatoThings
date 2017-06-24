//
//  TakeARestViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/5.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import ReactiveSwift

class TakeARestViewController: NSViewController {
  var task: Task
  var disposable: Disposable?
  
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
    
    disposable = TaskBLL.shared().taskSignal.observeValues {[unowned self] (task, type) -> () in
      switch type {
      case .startRest:
        self.enabelButtons(self.view, enable: false)
      case .endRest:
        self.enabelButtons(self.view, enable: true)
        self.dismiss(self)
        break
      default:
        break
      }
        
    }
  }
  
  deinit {
    if let d = disposable {
      d.dispose()
    }
  }
 
  // MARK: - actions
  @IBAction func onContinueBtnClicked(_ sender: AnyObject) {
    self.dismiss(self)
    
    // 继续干一个番茄
    TaskBLL.shared().startTomato(task)
  }
  
  fileprivate func enabelButtons(_ inview: NSView, enable: Bool) {
    for subview in inview.subviews {
      if let btn = subview as? NSButton {
        btn.isEnabled = enable
      }else {
        self.enabelButtons(subview, enable: enable)
      }
    }
  }
  
  @IBAction func onRestBtnClicked(_ sender: AnyObject) {
    TaskBLL.shared().startRest(task)
  }
  @IBAction func onFinishBtnClicked(_ sender: AnyObject) {
    self.dismiss(self)
    
    TaskBLL.shared().finishTask(task)
  }
}
