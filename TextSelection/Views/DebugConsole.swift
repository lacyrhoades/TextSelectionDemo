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
        
        self.label1 = UILabel()
        self.label1.numberOfLines = 0
        self.label1.font = self.label1.font.fontWithSize(8.0)
        self.label1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label1)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        
        let metrics = ["margin": 0]
        let views = ["label1": self.label1]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label1]|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label1]|", options: [], metrics: metrics, views: views))
    }
    
    var label1: UILabel!
    
    var text: String {
        get {
            if let text = self.label1.text {
                return text
            } else {
                return ""
            }
        }
        set {
            self.label1.text = newValue
        }
    }
}
