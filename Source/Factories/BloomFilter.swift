//
//  BloomFilter.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/27/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

protocol Queryable {
  func hash(seed: Int) -> UInt32
}

extension String: Queryable {
  func hash(seed: Int) -> UInt32 {
    return HashFunctions.murmur32(seed, str: self)
  }
}

extension Int: Queryable {
  func hash(seed: Int) -> UInt32 {
    return HashFunctions.murmur32(seed, str: (self.description))
  }
}

extension Double: Queryable {
  func hash(seed: Int) -> UInt32 {
    return HashFunctions.murmur32(seed, str: self.description)
  }
}

class BloomFilter {
  private var bitVector: BitVector
  //m is the optimal bit vector size.
  private var m = 0
  //k is the optimal number of hashes
  private var k = 0
  private var excp = NSException(name: "False Positive Error", reason: "Probability too high: 0 to 1", userInfo: nil)
  
  //n is the expected input size.
  //p is the probability of false positives.
  init(n: Int, p: Double) {
    let denominator: Double = (log(2.0) * (log(2.0)))
    let numerator: Double = Double(n) * log(p)
    m = Int( (numerator / denominator) * -1.0 )
    k = Int( (Double(m) / Double(n)) * log(2.0) )
    if m < 0 { excp.raise() }
    bitVector = BitVector(size: m)
  }
  
  
  //designate your desired array size and number of hashes
  init(m: Int, k: Int) {
    self.k = k
    self.m = m
    if m < 0 { excp.raise() }
    bitVector = BitVector(size: m)
  }
  
  
  func insert(item: Queryable) {
    if m == 0 || k == 0 { return }
    
    for var i = 0; i < k; i++ {
      let index = item.hash(i) % UInt32(m)
      bitVector[Int(index)] = true
    }
    
  }
  
  
  func query(item: Queryable) -> Bool {
    for var i = 0; i < k; i++ {
      let index = item.hash(i) % UInt32(m)
      let bit = bitVector[Int(index)]
        
      if bit == false { return false }
    }
    return true
 
  }
  
}
