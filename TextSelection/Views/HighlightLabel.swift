//
//  HighlightLabel.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/12/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

let translucentHightlightAlpha: CGFloat = 0.2

let highlightTextColor: UIColor = UIColor.yellowColor()
let highlightSelectionColor: UIColor = UIColor.blueColor()

let preSelectionTextColor: UIColor = UIColor.whiteColor()

class HighlightLabel: UIView {
    private var highlightSelection: Selection?
    var preSelection: Selection?
    var selection: Selection?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    var text: String? {
        didSet {
            if let newText = self.text {
                self.label.text = newText
            }
        }
    }
    
    var label: UILabel!
    private var hightlightBoundsView: UIView!
    func setup() {
        self.hightlightBoundsView = UIView()
        self.hightlightBoundsView.backgroundColor = highlightSelectionColor
        self.addSubview(self.hightlightBoundsView)
        
        self.label = UILabel()
        self.label.numberOfLines = 0
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)
        
        self.hightlightBoundsView.alpha = 0.0
        
        self.setupConstraints()
        
        self.setupTextManagers()
    }
    
    func setupConstraints() {
        let metrics = ["margin": 0]
        let views = ["label": self.label]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: metrics, views: views))
    }
    
    private var textStorage: NSTextStorage!
    private var layoutManager: NSLayoutManager!
    private var textContainer: NSTextContainer!
    
    func setupTextManagers() {
        self.textStorage = NSTextStorage()
        self.layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        self.textContainer = NSTextContainer(size: self.label.bounds.size)
        self.textContainer.lineFragmentPadding = 0
        self.textContainer.maximumNumberOfLines = self.label.numberOfLines
        self.textContainer.lineBreakMode = self.label.lineBreakMode
        self.layoutManager.addTextContainer(textContainer)
    }
    
    func updateTextManagers() {
        guard let text = self.label.attributedText as? NSMutableAttributedString else {
            return
        }
        
        text.setAttributes(self.baseAttributes, range: text.fullRange)
        self.textStorage.setAttributedString(text)
        self.textContainer.size = self.label.bounds.size
    }
    
    func updateViews() {
        if let highlightSelection = self.highlightSelection {
            let highlightedAttr = [NSForegroundColorAttributeName: highlightTextColor]
            textStorage.addAttributes(highlightedAttr, range:highlightSelection.range)
            let highlightBoundingRect = layoutManager.boundingRectForGlyphRange(highlightSelection.range, inTextContainer: textContainer)
            self.hightlightBoundsView.frame = highlightBoundingRect
            self.hightlightBoundsView.frame.origin.y = self.hightlightBoundsView.frame.origin.y + self.label.verticalOffset()
            self.hightlightBoundsView.alpha = translucentHightlightAlpha
        } else {
            textStorage.setAttributes(self.baseAttributes, range:textStorage.fullRange)
            self.hightlightBoundsView.frame = CGRectZero
            self.hightlightBoundsView.alpha = 0.0
        }
        
        if let preSelection = self.preSelection {
            //
        } else {
            //
        }
        
        if let selection = self.selection {
            //
        } else {
            //
        }
        
        self.label.attributedText = textStorage
    }
    
    var baseAttributes: [String: AnyObject] {
        get {
            return [NSFontAttributeName: self.label.font,
                    NSForegroundColorAttributeName: UIColor.darkTextColor()]
        }
    }
}

// Highlighting text
extension HighlightLabel {
    func startHighlighting(point: CGPoint) {
        self.updateTextManagers()
        
        let location = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let previousSpaceLocation = self.textStorage.string.nonWhitespaceCharacterIndexBefore(location)
        let nextSpaceLocation = self.textStorage.string.nonWhitespaceCharacterIndexAfter(location)

        let newSelection = Selection(first: previousSpaceLocation, last: nextSpaceLocation)
        
        self.highlightSelection = newSelection.add(self.highlightSelection)
        
        self.updateViews()
    }
    
    func continueHighlighting(point: CGPoint) {
        guard self.highlightSelection != nil else {
            return
        }
        
        self.updateTextManagers()
        
        let location = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if (location > self.highlightSelection!.first) {
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexAfter(location)
        } else {
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexBefore(location)
        }
        
        self.updateViews()
    }
    
    func finishHighlighting(point: CGPoint) {
        self.preSelection = self.highlightSelection
        self.highlightSelection = nil
        self.updateViews()
    }
}

// Touches began, ended etc.
extension HighlightLabel {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.startHighlighting(self.label.touchLocationInTextArea(touch))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.continueHighlighting(self.label.touchLocationInTextArea(touch))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.finishHighlighting(self.label.touchLocationInTextArea(touch))
        }
    }
}
