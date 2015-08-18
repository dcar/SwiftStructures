//
//  BitVector.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/30/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

protocol BitType {
  subscript(index: Int) -> Bool { get set }
}


class BitVector: BitType {
  private var data: [UInt8] = []
  
  init(size: Int) {
    data = [UInt8](count: self.byteIndex(size), repeatedValue: 0x00)
  }
  
  subscript(index: Int) -> Bool {
    get {
      let byte = data[byteIndex(index)]
      return 0 != (byte & mask(index))
    }
    
    set(value) {
      if value == true {
        let bIndex = byteIndex(index)
        data[bIndex] |= mask(index)
      }
      else {
        let bIndex = byteIndex(index)
        data[bIndex] &= ~(mask(index))
      }
    }
  }
    
  func byteIndex(index: Int) -> Int {
    //divide by 8
    return index >> 3
  }
    
  func mask(index: Int) -> UInt8 {
    //remainder of 8
    let shiftAmount = index & Int(0x07)
    //shift remainder bits left one
    return 0x01 << UInt8(shiftAmount)
  }

}
