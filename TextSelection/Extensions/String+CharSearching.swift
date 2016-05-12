//
//  String+CharSearching.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/13/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import Foundation

extension String {
    func nonWhitespaceCharacterIndexBefore(startingIndex: Int) -> Int {
        return self.nonWhitespaceCharacterIndexFrom(startingIndex, advanceBy: -1)
    }
    
    func nonWhitespaceCharacterIndexAfter(startingIndex: Int) -> Int {
        return self.nonWhitespaceCharacterIndexFrom(startingIndex, advanceBy: 1)
    }
    
    func nonWhitespaceCharacterIndexFrom(startingIndex: Int, advanceBy advance: Int) -> Int {
        var index = self.startIndex.advancedBy(startingIndex)
        var char = self[index]
        var position = self.startIndex.distanceTo(index)
        while (position > 0 && position < self.length - 1 && char != " ") {
            index = index.advancedBy(advance)
            position = self.startIndex.distanceTo(index)
            char = self[index]
        }
        return self.startIndex.distanceTo(index)
    }
    
    var length: Int {
        get {
            return self.startIndex.distanceTo(self.endIndex)
        }
    }
}