//
//  BitVector.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/30/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

protocol BitType {
  subscript(index: Int) -> Bool { get set}
}

private class SharedMethods {
  func byteIndex(index: Int) -> Int {
    //divide by 8
    return index >> 3
  }
  
  func mask(index: Int) -> UInt8 {
    //remainder of 8
    var shiftAmount = index & Int(0x07)
    //shift remainder bits left one
    return 0x01 << UInt8(shiftAmount)
  }
}

class BitVector: BitType {
  private var data: [UInt8]
  private var shared = SharedMethods()
  
  init(size: Int) {
    data = [UInt8](count: shared.byteIndex(size), repeatedValue: 0x00)
  }
  
  subscript(index: Int) -> Bool {
    get {
      var byte = data[shared.byteIndex(index)]
      return 0 != (byte & shared.mask(index))
    }
    
    set(value) {
      if value == true {
        let byteIndex = shared.byteIndex(index)
        data[byteIndex] |= shared.mask(index)
      }
      else {
        let byteIndex = shared.byteIndex(index)
        data[byteIndex] &= ~(shared.mask(index))
      }
    }
  }

}

class BitFile: BitType {
  private var location: String = ""
  private var shared = SharedMethods()
  
  init?(size: UInt64, location: String) {
    self.location = location
    var fileManager = NSFileManager.defaultManager()
    fileManager.createFileAtPath(location, contents: nil, attributes: nil)
    if let file = NSFileHandle(forWritingAtPath: location) {
      var data = NSData(bytes: [0x00], length: sizeof(CUnsignedChar))
      for var i: UInt64 = 0; i < (size >> 3); i++ {
        file.seekToFileOffset(i)
        file.writeData(data)
      }
    }
    else { return nil }
  }
  
  init?(location: String) {
    self.location = location
    if let file = NSMutableData(contentsOfFile: location) {
    }
    else { return nil }
  }
  
  subscript(index: Int) -> Bool {
    get {
      if let file = NSFileHandle(forReadingAtPath: location) {
        let byte = getByte(index, file)
        println(byte)
        file.closeFile()
        return 0 != (byte & shared.mask(index))
      }
      else { return false }
    }
    set(value) {
      if let file = NSFileHandle(forUpdatingAtPath: location) {
        var byte = getByte(index, file)
        println(byte)
        if value == true {
          byte |= shared.mask(index)
          let dataToWrite = NSData(bytes: [byte], length: sizeof(CUnsignedChar))
          let byteIndex = UInt64(shared.byteIndex(index))
          file.seekToFileOffset(byteIndex)
          file.writeData(dataToWrite)
          file.closeFile()
        }
      }
    }
  }
  
  private func getByte(index: Int, _ file: NSFileHandle) -> CUnsignedChar {
    let byteIndex = UInt64(shared.byteIndex(index))
    file.seekToFileOffset(byteIndex)
    var byte: CUnsignedChar = 0
    file.readDataOfLength(1).getBytes(&byte, length: sizeof(CUnsignedChar))
    return byte
  }
}