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

internal class SharedMethods {
  private func byteIndex(index: Int) -> Int {
    //divide by 8
    return index >> 3
  }
  
  private func mask(index: Int) -> UInt8 {
    //remainder of 8
    var shiftAmount = index & Int(0x07)
    //shift remainder bits left one
    return 0x01 << UInt8(shiftAmount)
  }
}

class BitVector: SharedMethods, BitType {
  private var data: [UInt8]
  
  init(size: Int) {
    data = [UInt8](count: size, repeatedValue: 0x00)
  }
  
  subscript(index: Int) -> Bool {
    get {
      var byte = data[byteIndex(index)]
      return 0 != (byte & mask(index))
    }
    
    set(value) {
      if value == true {
        data[byteIndex(index)] |= mask(index)
      }
      else {
        data[byteIndex(index)] &= ~(mask(index))
      }
    }
  }

}

class BitFile: SharedMethods, BitType {
  var location: String = ""
  
  init?(size: Int, location: String) {
    super.init()
    self.location = location
    var fileManager = NSFileManager.defaultManager()
    fileManager.createFileAtPath(location, contents: nil, attributes: nil)
    if let file = NSMutableData(contentsOfFile: location) {
      var byte = UnsafePointer<Void>(bitPattern: 0x00)
      for var i = 0; i < size; i++ {
        file.appendBytes(byte, length: sizeof(Void) * 1)
      }
    }
    else { return nil }
  }
  
  init?(location: String) {
    super.init()
    self.location = location
    if let file = NSMutableData(contentsOfFile: location) {
    }
    else { return nil }
  }
  
  subscript(index: Int) -> Bool {
    get {
      if let file = NSFileHandle(forReadingAtPath: location) {
        let byte = getByte(index, file)
        file.closeFile()
        return 0 != (byte & mask(index))
      }
      else { return false }
    }
    set(value) {
      if let file = NSFileHandle(forUpdatingAtPath: location) {
        var byte = getByte(index, file)
        if value == true {
          byte |= mask(index)
          let dataToWrite = NSData(bytes: [byte], length: sizeof(CUnsignedChar))
          file.writeData(dataToWrite)
          file.closeFile()
        }
      }
    }
  }
  
  private func getByte(index: Int, _ file: NSFileHandle) -> CUnsignedChar {
    file.seekToFileOffset(UInt64(index))
    var byte: CUnsignedChar = 0
    file.readDataOfLength(1).getBytes(&byte, length: sizeof(CUnsignedChar)*1)
    return byte
  }
}