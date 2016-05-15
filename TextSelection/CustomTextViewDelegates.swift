//
//  CustomTextViewDelegates.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/13/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

protocol HighlightLabelDelegate: class {
    func labelSelectionDidChange()
}

protocol MultitouchTextViewDelegate: class {
    func labelSelectionDidChange()
}
