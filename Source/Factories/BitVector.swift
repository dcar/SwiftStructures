//
//  BitVector.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/30/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

class BitVector {
  private var arr: [UInt8]
  
  init(size: Int) {
    arr = [UInt8](count: size, repeatedValue: 0x00)
  }
  
  subscript(index: Int) -> Bool {
    get {
      var byte = arr[byteIndex(index)]
      return 0 != (byte & mask(index))
    }
    
    set(value) {
      if value == true {
        arr[byteIndex(index)] |= mask(index)
      }
      else {
        arr[byteIndex(index)] &= ~(mask(index))
      }
    }
  }
  
  private func byteIndex(index: Int) -> Int {
    return index >> 3
  }
  
  private func mask(index: Int) -> UInt8 {
    var shiftAmount = index & Int(0x07)
    return 0x01 << UInt8(shiftAmount)
  }
}