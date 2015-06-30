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
  var bitVector = BitVector(size: 22)
  
  func testFalse() {
    bitVector[0] = false
    var value = bitVector[0]
    XCTAssert(value == false, "value Should be false.")
  }
  
  func testTrue() {
    bitVector[0] = true
    var value = bitVector[0]
    XCTAssert(value == true, "value Should be true.")
  }

}