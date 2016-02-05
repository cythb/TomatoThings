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
  }
  
  @IBAction func onRestBtnClicked(sender: AnyObject) {
    
    self.dismissController(self)
  }
}
