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
  private var file: NSFileHandle?
  private var shared = SharedMethods()
  
  init?(size: UInt64, location: String) {
    var fileManager = NSFileManager.defaultManager()
    let created = fileManager.createFileAtPath(location, contents: nil, attributes: nil)
    if created {
      file = NSFileHandle(forUpdatingAtPath: location)
      var data = NSData(bytes: [0x00], length: sizeofValue(0x00))
      for var i: UInt64 = 0; i < (size >> 3); i++ {
        file?.seekToFileOffset(i)
        file?.writeData(data)
      }
    }
    else { return nil }
  }
  
  init?(location: String) {
    var fileManager = NSFileManager.defaultManager()
    let exists = fileManager.fileExistsAtPath(location)
    if exists {
      self.file = NSFileHandle(forUpdatingAtPath: location)
    }
    else { return nil }
  }
  
  subscript(index: Int) -> Bool {
    
    get {
      let byteIndex = UInt64(shared.byteIndex(index))
      let byte = getByte(byteIndex)
      return 0 != (byte & shared.mask(index))
    }
    
    set(value) {
      let byteIndex = UInt64(shared.byteIndex(index))
      file?.seekToFileOffset(byteIndex)
      var byte = getByte(byteIndex)
      
      if value == true {
        byte |= shared.mask(index)
        writeByte(byte, byteIndex)
      }
      else {
        byte &= ~(shared.mask(index))
        writeByte(byte, byteIndex)
      }
      
    }
  }
  
  func printAll() {
    file?.seekToFileOffset(0)
    println(file!.readDataToEndOfFile())
  }
  
  private func getByte(byteIndex: UInt64) -> UInt8 {
    file?.seekToFileOffset(byteIndex)
    var bytes: [UInt8] = [0x00]
    let data = file!.readDataOfLength(1)
    data.getBytes(&bytes, length: 1)
    println(data)
    return bytes[0]
  }
  
  private func writeByte(byte: UInt8, _ byteIndex: UInt64) {
    file?.seekToFileOffset(byteIndex)
    let dataToWrite = NSData(bytes: [byte as CUnsignedChar], length: 1)
    file?.writeData(dataToWrite)
  }
  
  deinit {
    file?.closeFile()
  }
}