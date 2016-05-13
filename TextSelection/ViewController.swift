//
//  ViewController.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/12/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

let margin: CGFloat = 15.0

enum DebugMode {
    case ShowConsole
}

class ViewController: UIViewController {

    var mode: [DebugMode] = []
    
    var scrollView: UIScrollView!
    var label: HighlightLabel!
    var button: UIButton!
    var debugConsole: DebugConsole!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        
        self.label = HighlightLabel()
        self.label.delegate = self
        self.label.text = "The UIKit framework includes several classes whose purpose is to display text in an app’s user interface: UITextView, UITextField, UILabel, and UIWebView, as described in Displaying Text Content in iOS. Text views, created from the UITextView class, are meant to display large amounts of text. Underlying UITextView is a powerful layout engine called Text Kit. If you need to customize the layout process or you need to intervene in that behavior, you can use Text Kit. For smaller amounts of text and special needs requiring custom solutions, you can use alternative, lower-level technologies, as described in Lower Level Text-Handling Technologies.\n\nText Kit is a set of classes and protocols in the UIKit framework providing high-quality typographical services that enable apps to store, lay out, and display text with all the characteristics of fine typesetting, such as kerning, ligatures, line breaking, and justification. Text Kit is built on top of Core Text, so it provides the same speed and power. UITextView is fully integrated with Text Kit; it provides editing and display capabilities that enable users to input text, specify formatting attributes, and view the results. The other Text Kit classes provide text storage and layout capabilities. Figure 9-1 shows the position of Text Kit among other iOS text and graphics frameworks.\n\nAn NSTextContainer object defines a region where text can be laid out. Typically, a text container defines a rectangular area, but by creating a subclass of NSTextContainer you can create other shapes: circles, pentagons, or irregular shapes, for example. Not only does a text container describe the outline of an area that can be filled with text, it maintains an array of Bezier paths that are exclusion zones within its area where text is not laid out. As it is laid out, text flows around the exclusion paths, providing a means to include graphics and other non-text layout elements.\n\nNSTextStorage defines the fundamental storage mechanism of the Text Kit’s extended text-handling system. NSTextStorage is a subclass of NSMutableAttributedString that stores the characters and attributes manipulated by the text system. It ensures that text and attributes are maintained in a consistent state across editing operations. In addition to storing the text, an NSTextStorage object manages a set of client NSLayoutManager objects, notifying them of any changes to its characters or attributes so that they can relay and redisplay the text as needed.\n\nAn NSLayoutManager object orchestrates the operation of the other text handling objects. It intercedes in operations that convert the data in an NSTextStorage object to rendered text in a view’s display area. It maps Unicode character codes to glyphs and oversees the layout of the glyphs within the areas defined by NSTextContainer objects.\n\nNote: NLayoutManager, NSTextStorage, and NSTextContainer can be accessed from subthreads as long as the app guarantees the access from a single thread.\n\nFor reference information about UITextView, see UITextView Class Reference. NSTextContainer is described in NSTextContainer Class Reference for iOS, NSLayoutManager in NSLayoutManager Class Reference for iOS, and NSTextStorage in NSTextStorage Class Reference for iOS."
        self.label.userInteractionEnabled = true
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.label)
        
        if (self.showConsole) {
            self.debugConsole = DebugConsole()
            self.debugConsole.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.debugConsole)
            
            self.labelSelectionDidChange()
        }
        
        self.button = UIButton(type:.Custom)
        self.button.alpha = 0.0
        self.button.addTarget(self, action: #selector(didTapButton), forControlEvents: .TouchUpInside)
        self.button .setBackgroundImage(UIImage(named: "blue_circle"), forState: .Normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.button)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        let metrics = ["margin": margin, "buttonMargin": -60.0]
        var views: [String: AnyObject] = ["label": self.label, "button": self.button, "scrollView": self.scrollView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[scrollView]-margin-|", options: [], metrics: metrics, views: views))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.label, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: -2 * margin))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.label, attribute: .CenterX, relatedBy: .Equal, toItem: self.scrollView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(==175.0)]-buttonMargin-|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(==175.0)]-buttonMargin-|", options: [], metrics: metrics, views: views))
        
        if (self.showConsole) {
            views["debugConsole"] = self.debugConsole
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[debugConsole]-margin-|", options: [], metrics: metrics, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[scrollView]-margin-[debugConsole]-margin-|", options: [], metrics: metrics, views: views))
        } else {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[scrollView]-margin-|", options: [], metrics: metrics, views: views))
            self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[label]-margin-|", options: [], metrics: metrics, views: views))
        }
    }
    
    var showConsole: Bool {
        get {
            return self.mode.contains(.ShowConsole)
        }
    }
    
    func didTapButton() {
        if (self.label.selection != nil && self.label.preSelection == nil) {
            self.label.clearSelection()
        } else {
            self.label.appendPreSelectionToSelection()
        }
    }
}

extension ViewController: HighlightLabelDelegate {
    func labelSelectionDidChange() {
        let hide = self.label.selection == nil && self.label.preSelection == nil && self.label.highlightSelection == nil
        
        let alpha: CGFloat = hide ? 0.0 : 0.75
        
        UIView.animateWithDuration(0.3, animations: {
            self.button.alpha = alpha
        })
        
        if (!self.showConsole) {
            return
        }
        
        var string = "Noting Selected"
        if let selectedText = self.label.selectedText {
            string = selectedText
        }
        
        self.debugConsole.text = string
    }
}