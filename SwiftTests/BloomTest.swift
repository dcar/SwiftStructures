//
//  BloomTest.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/29/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import UIKit
import XCTest

class BloomTest: XCTestCase {
  var filter = BloomFilter(n: 4000000, p: 0.000000000001)
  
  func testFail() {
    let query = filter.query(2)
    XCTAssert(query == false, "2 should not be in the filter.")
  }
  
  func testInsert() {
    for var i = 0; i < 4000; i++ {
      filter.insert(i)
    }
    
    var checkInsertion: () -> Bool = { () -> Bool in
      for var i = 0; i < 4000; i++ {
        var query = self.filter.query(i)
        if query == false { return false }
      }
      return true
    }
    
    XCTAssert(checkInsertion() == true, "Values 0 to 3999 should be in the filter.")
  }
  
  
}