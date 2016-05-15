//
//  HighlightLabel.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/12/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

let translucentHightlightAlpha: CGFloat = 0.2
let translucentPreSelectionAlpha: CGFloat = 0.5
let translucentSelectionAlpha: CGFloat = 1.0

let highlightTextColor: UIColor = UIColor.whiteColor()
let highlightSelectionColor: UIColor = UIColor(red: 164/255.0, green: 164/255.0, blue: 164/255.0, alpha: 1)

let preSelectionTextColor: UIColor = UIColor.whiteColor()
let preSelectionColor: UIColor = UIColor(red: 131/255.0, green: 141/255.0, blue: 153/255.0, alpha: 1)

let selectionTextColor: UIColor = UIColor.whiteColor()
let selectionColor: UIColor = UIColor(red: 25/255.0, green: 133/255.0, blue: 255/255.0, alpha: 1)


class HighlightLabel: UIView {
    weak var delegate: HighlightLabelDelegate?
    
    var highlightSelection: Selection?
    var preSelection: Selection?
    var selection: Selection?
    
    var selectedText: String? {
        get {
            guard let selection = self.selection, text = self.text else {
                return nil
            }
            
            return (text as NSString).substringWithRange(selection.range)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    var text: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }
    
    var label: UILabel!
    private var hightlightBoundsView: HighlightRegionView!
    private var preSelectionBoundsView: HighlightRegionView!
    private var selectionBoundsView: HighlightRegionView!
    func setup() {
        self.selectionBoundsView = HighlightRegionView()
        self.selectionBoundsView.backgroundColor = selectionColor
        self.selectionBoundsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.selectionBoundsView)
        
        self.preSelectionBoundsView = HighlightRegionView()
        self.preSelectionBoundsView.backgroundColor = preSelectionColor
        self.preSelectionBoundsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.preSelectionBoundsView)
        
        self.hightlightBoundsView = HighlightRegionView()
        self.hightlightBoundsView.backgroundColor = highlightSelectionColor
        self.hightlightBoundsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.hightlightBoundsView)
        
        self.label = UILabel()
        self.label.numberOfLines = 0
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.label)
        
        self.setupConstraints()
        
        self.setupTextManagers()
        
        self.updateViews(false)
    }
    
    func setupConstraints() {
        let metrics = ["margin": 0]
        let views = [
            "label": self.label,
            "hightlightBoundsView": self.hightlightBoundsView,
            "preSelectionBoundsView": self.preSelectionBoundsView,
            "selectionBoundsView": self.selectionBoundsView
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: metrics, views: views))
        
        self.addConstraint(NSLayoutConstraint(item: self.hightlightBoundsView, attribute: .Top, relatedBy: .Equal, toItem: self.label, attribute: .Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.hightlightBoundsView, attribute: .Bottom, relatedBy: .Equal, toItem: self.label, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.hightlightBoundsView, attribute: .Leading, relatedBy: .Equal, toItem: self.label, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.hightlightBoundsView, attribute: .Trailing, relatedBy: .Equal, toItem: self.label, attribute: .Trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.preSelectionBoundsView, attribute: .Top, relatedBy: .Equal, toItem: self.label, attribute: .Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.preSelectionBoundsView, attribute: .Bottom, relatedBy: .Equal, toItem: self.label, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.preSelectionBoundsView, attribute: .Leading, relatedBy: .Equal, toItem: self.label, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.preSelectionBoundsView, attribute: .Trailing, relatedBy: .Equal, toItem: self.label, attribute: .Trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.selectionBoundsView, attribute: .Top, relatedBy: .Equal, toItem: self.label, attribute: .Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.selectionBoundsView, attribute: .Bottom, relatedBy: .Equal, toItem: self.label, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.selectionBoundsView, attribute: .Leading, relatedBy: .Equal, toItem: self.label, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.selectionBoundsView, attribute: .Trailing, relatedBy: .Equal, toItem: self.label, attribute: .Trailing, multiplier: 1, constant: 0))
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
    
    func updateViews(animated: Bool) {
        self.textStorage.setAttributes(self.baseAttributes, range:textStorage.fullRange)
        
        self.selectionBoundsView.alpha = 0.0
        
        if (animated) {
            UIView.animateWithDuration(0.3, animations: {
                self.preSelectionBoundsView.alpha = 0.0
            })
        } else {
            self.preSelectionBoundsView.alpha = 0.0
        }
        
        self.hightlightBoundsView.alpha = 0.0

        if let highlightSelection = self.highlightSelection {
            self.highlightRange(highlightSelection, attributes: [NSForegroundColorAttributeName: highlightTextColor], regionView: self.hightlightBoundsView, alpha: translucentHightlightAlpha)
        }
        
        if let preSelection = self.preSelection {
            self.highlightRange(preSelection, attributes: [NSForegroundColorAttributeName: preSelectionTextColor], regionView: self.preSelectionBoundsView, alpha: translucentPreSelectionAlpha)
        }
        
        if let selection = self.selection {
            self.highlightRange(selection, attributes: [NSForegroundColorAttributeName: selectionTextColor], regionView: self.selectionBoundsView, alpha: translucentSelectionAlpha)
        }
        
        self.label.attributedText = textStorage
    }
    
    func highlightRange(selection: Selection, attributes: [String: AnyObject], regionView: HighlightRegionView, alpha: CGFloat) {
        
        self.textStorage.addAttributes(attributes, range:selection.range)
        
        let firstCharRange = NSMakeRange(selection.range.location, 1)
        let lastCharRange = NSMakeRange(selection.range.location + selection.range.length - 1, 1)
        
        var firstCharBoundingRect = self.layoutManager.boundingRectForGlyphRange(firstCharRange, inTextContainer: self.textContainer)
        var lastCharBoundingRect = self.layoutManager.boundingRectForGlyphRange(lastCharRange, inTextContainer: self.textContainer)
        
        firstCharBoundingRect.origin.y = firstCharBoundingRect.origin.y + self.label.verticalOffset()
        lastCharBoundingRect.origin.y = lastCharBoundingRect.origin.y + self.label.verticalOffset()
        
        regionView.setup(firstCharBoundingRect, end: lastCharBoundingRect)
        
        regionView.alpha = alpha
    }
    
    var baseAttributes: [String: AnyObject] {
        get {
            return [NSFontAttributeName: self.label.font,
                    NSForegroundColorAttributeName: UIColor.darkTextColor()]
        }
    }
    
    var preSelectionTimer: NSTimer?
    func clearPreSelectionWithDelay() {
        self.preSelectionTimer?.invalidate()
        
        self.preSelectionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(clearPreSelection), userInfo: nil, repeats: false)
    }
}

// Highlighting text
extension HighlightLabel {
    func startHighlighting(point: CGPoint) {
        self.updateTextManagers()
        
        let location = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let previousSpaceLocation = self.textStorage.string.nonWhitespaceCharacterIndexBefore(location)
        let nextSpaceLocation = self.textStorage.string.nonWhitespaceCharacterIndexAfter(location)

        let newSelection = Selection(first: previousSpaceLocation, last: nextSpaceLocation, attributes: [NSForegroundColorAttributeName: highlightTextColor, NSBackgroundColorAttributeName: highlightSelectionColor])
        
        self.highlightSelection = newSelection.add(self.highlightSelection)
        self.preSelection = nil
        
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func continueHighlighting(point: CGPoint) {
        guard self.highlightSelection != nil else {
            return
        }
        
        self.updateTextManagers()
        
        let location = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if (location > self.highlightSelection!.first) {
            self.highlightSelection!.first = self.highlightSelection!.start
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexAfter(location)
        } else {
            self.highlightSelection!.first = self.highlightSelection!.end
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexBefore(location)
        }
        
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func finishHighlighting(point: CGPoint) {
        guard let highlightSelection = self.highlightSelection else {
            return
        }
        self.preSelection = highlightSelection.add(self.preSelection)
        self.preSelection?.attributes = [NSForegroundColorAttributeName: preSelectionTextColor, NSBackgroundColorAttributeName: preSelectionColor]
        self.highlightSelection = nil
        self.updateViews(false)
        self.selectionDidChange()
        
        self.clearPreSelectionWithDelay()
    }
    
    func appendPreSelectionToSelection() {
        guard let preSelection = self.preSelection else {
            return
        }
        self.selection = preSelection.add(self.selection)
        self.selection?.attributes = [NSForegroundColorAttributeName: selectionTextColor, NSBackgroundColorAttributeName: selectionColor]
        self.preSelection = nil
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func clearPreSelection() {
        self.preSelection = nil
        self.updateViews(true)
        self.selectionDidChange()
    }
    
    func clearSelection() {
        self.preSelectionTimer?.invalidate()
        self.highlightSelection = nil
        self.preSelection = nil
        self.selection = nil
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func selectionDidChange() {
        if let delegate = self.delegate {
            delegate.labelSelectionDidChange()
        }
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
