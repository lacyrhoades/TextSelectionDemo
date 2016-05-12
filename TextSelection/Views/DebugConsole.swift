//
//  DebugConsole.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/13/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class DebugConsole: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200))
    }
}
