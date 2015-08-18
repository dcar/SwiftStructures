//
//  HashFunctions.swift
//  SwiftStructures
//
//  Created by Dominick Carro on 6/30/15.
//  Copyright (c) 2015 Arbutus Software Inc. All rights reserved.
//

import Foundation

struct HashFunctions {
  static func murmur32(seed: Int, str: String) -> UInt32 {
    let len = CInt(str.characters.count)
    return MurmurHashAligned2(str, len, CUnsignedInt(seed))
  }
}