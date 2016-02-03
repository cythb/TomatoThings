//
//  CoreDataHelperTests.swift
//  TomatoThings
//
//  Created by tanghaibo on 16/2/3.
//  Copyright © 2016年 tanghaibo. All rights reserved.
//

import XCTest
@testable import TomatoThings

class CoreDataHelperTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCreateEntity() {
    let task = CoreDataHelper.createEntity("Task") as? Task
    XCTAssert(nil != task)
  }
}
