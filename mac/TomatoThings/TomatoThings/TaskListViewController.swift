//
//  TaskListViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa

class TaskListViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 1
    }
    
    // MARK: - NSTableViewDelegate
    func tableView(tableView:NSTableView, viewForTableColumn tableColumn:NSTableColumn?, row:Int) -> NSView?
    {
        let view = tableView.makeViewWithIdentifier("inputCell", owner: nil)
        
        return view
    }
}
