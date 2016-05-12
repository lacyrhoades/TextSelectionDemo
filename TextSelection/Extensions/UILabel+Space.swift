//
//  UILabel+Space.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/13/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

extension UILabel {
    func verticalOffset() -> CGFloat {
        guard let attributedString = self.attributedText else {
            return 0
        }
        let frameSize = CGSize(width: self.bounds.width, height: CGFloat.max)
        let boundingRect = attributedString.boundingRectWithSize(frameSize, options: [NSStringDrawingOptions.UsesLineFragmentOrigin], context: nil)
        return (self.bounds.height - boundingRect.size.height) / 2.0
    }
    
    func touchLocationInTextArea(touch: UITouch) -> CGPoint {
        var point = touch.locationInView(self)
        point.y = point.y - self.verticalOffset()
        return point
    }
}
