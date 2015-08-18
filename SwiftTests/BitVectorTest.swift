//
//  BitVectorTest.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/30/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import UIKit
import XCTest

class BitVectorTest: XCTestCase {
  var bitVector: BitVector?
  
  override func setUp() {
    super.setUp()
    bitVector = BitVector(size: 10000)
  }
  
  func testFalse() {
    bitVector![5] = true
    bitVector![5] = false
    let value = bitVector?[5]
    XCTAssert(value == false, "value Should be false.")
  }
  
  func testTrue() {
    bitVector![0] = true
    let value = bitVector![0]
    XCTAssert(value == true, "value Should be true.")
  }


}