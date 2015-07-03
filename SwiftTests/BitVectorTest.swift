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
  var bitFile: BitFile?
  
  override func setUp() {
    super.setUp()
    bitVector = BitVector(size: 10000)
    bitFile = BitFile(size: 1000, location: "/Users/Dom/bit-file.dat")!
  }
  
  func testFalse() {
    bitVector?[5] = true
    bitVector?[5] = false
    var value = bitVector?[5]
    XCTAssert(value == false, "value Should be false.")
  }
  
  func testTrue() {
    bitVector?[0] = true
    var value = bitVector?[0]
    XCTAssert(value == true, "value Should be true.")
  }
  
  func testBitFileTrue() {
    bitFile?[545] = true
    bitFile!.printAll()
    var value = bitFile?[545]
    XCTAssert(value == true, "value Should be true.")
    bitFile?[544] = true
    value = bitFile?[544]
    bitFile!.printAll()
    XCTAssert(value == true, "value Should be true.")
  }


}