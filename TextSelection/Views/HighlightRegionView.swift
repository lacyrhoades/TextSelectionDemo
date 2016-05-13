//
//  HighlightRegionView.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/13/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class HighlightRegionView: UIView {
    var region1: UIView!
    var region2: UIView!
    var region3: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.region2 = UIView()
        self.addSubview(self.region2)
        
        self.region1 = UIView()
        self.addSubview(self.region1)
        
        self.region3 = UIView()
        self.addSubview(self.region3)
    }

    override var backgroundColor: UIColor? {
        get {
            return UIColor.clearColor()
        }
        set {
            if (newValue != nil) {
                self.region1.backgroundColor = newValue
                self.region2.backgroundColor = newValue
                self.region3.backgroundColor = newValue
            }
            super.backgroundColor = UIColor.clearColor()
        }
    }
    
    func setup(start: CGRect, end: CGRect) {
        let x = start.origin.x
        self.region1.frame = CGRectMake(x, start.origin.y, self.frame.width - x, start.height)
        self.region3.frame = CGRectMake(0, end.origin.y, end.maxX, end.height)
        self.updateRegion2()
    }
    
    func updateRegion2() {
        let minY = self.region1.frame.maxY
        var height = self.region3.frame.minY - self.region1.frame.maxY
        if (self.region3.frame.origin.y == self.region1.frame.origin.y) {
            height = 0
            let x1 = self.region1.frame.origin.x
            let x3 = self.region3.frame.maxX
            self.region1.frame = CGRectMake(x1, self.region1.frame.origin.y, x3 - x1, self.region1.frame.height)
            self.region3.frame = self.region1.frame
        }
        self.region2.frame = CGRectMake(0, minY, self.frame.width, height)
    }
}
