//
//  BloomFilter.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/27/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

struct Murmur {
  static func hash(seed: Int, str: String) -> UInt32 {
    var len = CInt(count(str))
    return MurmurHashAligned2(str, len, CUnsignedInt(seed))
  }  
}

protocol Murmable {
  func hash(seed: Int) -> UInt32
}

extension String: Murmable {
  func hash(seed: Int) -> UInt32 {
    return Murmur.hash(seed, str: self)
  }
}

extension Int: Murmable {
  func hash(seed: Int) -> UInt32 {
    return Murmur.hash(seed, str: (self.description))
  }
}

extension Double: Murmable {
  func hash(seed: Int) -> UInt32 {
    return Murmur.hash(seed, str: self.description)
  }
}

class BloomFilter {
  private var bitVector: CFMutableBitVectorRef
  //m is the optimal bit vector size.
  private var m = 0
  //k is the optimal number of hashes
  private var k = 0
  
  //n is the expected input size.
  //p is the probability of false positives.
  init(n: Int, p: Double) {
    let denominator: Double = (log(2.0) * (log(2.0)))
    let numerator: Double = Double(n) * log(p)
    m = Int( (numerator / denominator) * -1.0 )
    k = Int( (Double(m) / Double(n)) * log(2.0) )
    bitVector = CFBitVectorCreateMutable(nil, m)
  }
  
  func insert(item: Murmable) {
    if m == 0 || k == 0 { return }
    
    for var i = 0; i < k; i++ {
      let index = item.hash(i) % UInt32(m)
      CFBitVectorSetBitAtIndex(bitVector, Int(index), 1)
    }
    
  }
  
  func query(item: Murmable) -> Bool {
    for var i = 0; i < k; i++ {
      let index = item.hash(i) % UInt32(m)
      let bit = CFBitVectorGetBitAtIndex(bitVector, Int(index))
        
      if bit == 0 { return false }
    }
    return true
 
  }
  
  
}
