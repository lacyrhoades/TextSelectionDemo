//
//  MultitouchTextView.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/15/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class MultitouchTextView: UITextView {
    private var highlightSelection: Selection?
    private var preSelection: Selection?
    private var selection: Selection?
    
    var customDelegate: MultitouchTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup() {
        self.editable = false
        
        self.gestureRecognizers?.forEach({ (recognizer) in
            switch Mirror(reflecting: recognizer).subjectType {
            case is UILongPressGestureRecognizer.Type:
                // For normal selections
                self.removeGestureRecognizer(recognizer)
                break
            case is UITapGestureRecognizer.Type:
                // Not sure what this is
                // Probably "cancels" selections
                self.removeGestureRecognizer(recognizer)
                break
            case is UIPanGestureRecognizer.Type:
                // For scrolling
                let pan = recognizer as! UIPanGestureRecognizer
                pan.minimumNumberOfTouches = 2
                break
            default:
                let className = String(Mirror(reflecting: recognizer).subjectType)
                if (className == "UITapAndAHalfRecognizer") {
                    // For tap and drag
                    self.removeGestureRecognizer(recognizer)
                } else if (className == "_UIPreviewInteractionTouchObservingGestureRecognizer") {
                    // Not sure what this is
                }
                break
            }
        })
    }
    
    var baseAttributes: [String: AnyObject] {
        get {
            return [NSForegroundColorAttributeName: UIColor.darkTextColor()]
        }
    }
    
    var preSelectionTimer: NSTimer?
    
    func clearPreSelectionWithDelay() {
        self.preSelectionTimer?.invalidate()
        self.preSelectionTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(clearPreSelection), userInfo: nil, repeats: false)
    }
    
    func clearPreSelection() {
        self.preSelection = nil
        self.updateViews(true)
        self.selectionDidChange()
    }
    
    func didTapButton() {
        if (self.selection != nil && self.preSelection == nil) {
            self.clearSelection()
        } else {
            self.appendPreSelectionToSelection()
        }
    }
    
    var shouldShowControlButton: Bool {
        get {
            return self.selection != nil || self.preSelection != nil
        }
    }
}

extension MultitouchTextView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self.textInputView) {
            self.startHighlighting(point)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self.textInputView) {
            self.continueHighlighting(point)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let point = touches.first?.locationInView(self.textInputView) {
            self.endHighlighting(point)
        }
    }
}

extension MultitouchTextView {
    func startHighlighting(point: CGPoint) {
        let index = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let before = self.textStorage.string.nonWhitespaceCharacterIndexBefore(index)
        let after = self.textStorage.string.nonWhitespaceCharacterIndexAfter(index)
        
        let newSelection = Selection(first: before, last: after, attributes: [NSForegroundColorAttributeName: highlightTextColor, NSBackgroundColorAttributeName: highlightSelectionColor])
        
        self.highlightSelection = newSelection
        self.preSelection = nil
        
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func continueHighlighting(point: CGPoint) {
        guard self.highlightSelection != nil else {
            return
        }
        
        let index = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if (index > self.highlightSelection!.first) {
            self.highlightSelection!.first = self.highlightSelection!.start
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexAfter(index)
        } else {
            self.highlightSelection!.first = self.highlightSelection!.end
            self.highlightSelection!.last = self.textStorage.string.nonWhitespaceCharacterIndexBefore(index)
        }
        
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func endHighlighting(point: CGPoint) {
        guard self.highlightSelection != nil else {
            return
        }
        
        self.preSelection = self.highlightSelection!.add(self.preSelection)
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
    
    func clearSelection() {
        self.preSelectionTimer?.invalidate()
        self.highlightSelection = nil
        self.preSelection = nil
        self.selection = nil
        self.updateViews(false)
        self.selectionDidChange()
    }
    
    func updateViews(animated: Bool) {
        if (animated) {
            UIView.transitionWithView(self.textInputView, duration: 0.3, options: [.TransitionCrossDissolve], animations: {
                self.updateTextAttributes()
                }) { (done) in
                    // done
            }
        } else {
            self.updateTextAttributes()
        }
    }
    
    func updateTextAttributes() {
        self.textStorage.beginEditing()
        
        self.textStorage.setAttributes(self.baseAttributes, range:self.textStorage.fullRange)
        
        if let highlightSelection = self.highlightSelection {
            self.textStorage.addAttributes(highlightSelection.attributes, range:highlightSelection.range)
        }
        
        if let preSelection = self.preSelection {
            self.textStorage.addAttributes(preSelection.attributes, range:preSelection.range)
        }
        
        if let selection = self.selection {
            self.textStorage.addAttributes(selection.attributes, range:selection.range)
        }
        
        self.textStorage.endEditing()
    }
    
    func selectionDidChange() {
        if let delegate = self.customDelegate {
            delegate.labelSelectionDidChange()
        }
    }
}