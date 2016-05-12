//
//  NSAttributedString+TextSelection.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/12/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

extension NSAttributedString {
    var fullRange: NSRange {
        get {
            return NSMakeRange(0, self.length)
        }
    }
}