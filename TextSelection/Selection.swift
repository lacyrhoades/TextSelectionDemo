//
//  Selection.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/12/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import Foundation

struct Selection {
    
    var first: Int
    var last: Int
    var start: Int {
        get {
            return min(first,last)
        }
    }
    var end: Int {
        get {
            return max(first,last)
        }
    }
    
    var range: NSRange {
        get {
            return NSMakeRange(self.start, self.end - self.start + 1)
        }
    }
    
    func add(newSelection: Selection?) -> Selection {
        guard let selection = newSelection else {
            return self
        }
        
        let start = min(selection.start, self.start)
        let end = max(selection.end, self.end)
        
        return Selection(first: start, last: end)
    }
}
