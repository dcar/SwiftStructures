//
//  extensions.swift
//  SwiftStructures
//
//  Created by Wayne Bishop on 8/20/14.
//  Copyright (c) 2014 Arbutus Software Inc. All rights reserved.
//

import Foundation


extension String {
  
    
    //compute the length of string
    var length: Int {
        return (self.characters.count)
    }
    
    //returns characters of a string up to a specified index
    func substringToIndex(to: Int) -> String {
        return self.substringToIndex(advance(self.startIndex, to))
    }
    
    
    //return a character at a specific index
    func stringAtIndex(position: Int) -> String {
        return String(Array(self.characters)[position])
    }

    
    //insert a string at a specified index
    func insertSubstring(string:String, index:Int) -> String {
        let midIndex = advance(self.startIndex, (self.length - index))
        let prefix = self[self.startIndex...midIndex]
        let suffix = self[midIndex...self.endIndex]
        return  prefix + string + suffix
    }

    
}





extension Int {
    
    //iterates the closure body a specified number of times
	func times(closure:(Int)->Void) {
		for i in 0...self {
			closure(i)
		}
	}
	
}