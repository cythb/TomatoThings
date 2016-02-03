//
//  TaskDALTest.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import XCTest
@testable import TomatoThings

class TaskDALTest: XCTestCase {
  var dal = TaskDAL()
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testAddTask() {
    let task = dal.addTask("title", eNUMT: 3)
    XCTAssert(task?.title == "title")
    XCTAssert(task?.estimateNUMT == 3)
  }
  
  func testRemoveTask() {
    let task = dal.addTask("t1", eNUMT: 4)
    dal.removeTask(task!)
    XCTAssert(task!.deleted)
  }
}
