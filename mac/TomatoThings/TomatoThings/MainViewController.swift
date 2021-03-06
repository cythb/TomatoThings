//
//  MainViewController.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/1/27.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import Cocoa
import SnapKit

/// 主视图控制器，主要管理视图结构
class MainViewController: NSViewController {
    @IBOutlet weak var splitView: NSSplitView!
    
    lazy var boxListVC: BoxListViewController = {
        BoxListViewController()
    }()
    
    lazy var taskListVC: TaskListViewController = {
        TaskListViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    fileprivate func setupViews() {
        let arrangedSubviews = splitView.arrangedSubviews;
        guard let leftContainerView = arrangedSubviews[0] as NSView!,
            let mainContainerView = arrangedSubviews[1] as NSView!, arrangedSubviews.count > 1
            else {
                return
        }
        
        leftContainerView.addSubview(boxListVC.view)
        boxListVC.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(NSEdgeInsetsZero)
        }
        
        mainContainerView.addSubview(taskListVC.view)
        taskListVC.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(NSEdgeInsetsZero)
        }
    }
}
