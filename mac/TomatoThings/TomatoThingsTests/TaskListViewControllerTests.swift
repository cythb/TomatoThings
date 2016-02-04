//
//  TaskListViewControllerTests.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/4.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import XCTest
@testable import TomatoThings

class TaskListViewControllerTests: XCTestCase {

  var taskListVC = TaskListViewController()
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseInputString() {
      // this is a title -e 3
      // -t this is a title -e 3
      // -e 3 this is a title
      // -e 3 -t this is a title
      let (title, eNumT) = taskListVC.parseInputString("this is a title -e 3")
      let (title1, eNumT1) = taskListVC.parseInputString("-t this is a title -e 3")
      let (title2, eNumT2) = taskListVC.parseInputString("-t -c this is a title -e 4")
      
      XCTAssert(title == "this is a title" && eNumT == 3)
      XCTAssert(title1 == "-t this is a title" && eNumT1 == 3)
      XCTAssert(title2 == "-t" && eNumT2 == 4)
    }

}
