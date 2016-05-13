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
    
    var label: HighlightLabel!
    var button: UIButton!
    var debugConsole: DebugConsole!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mode.append(.ShowConsole)
        
        self.label = HighlightLabel()
        self.label.delegate = self
        self.label.text = "Text views, created from the UITextView class, are meant to display large amounts of text. Underlying UITextView is a powerful layout engine called Text Kit. If you need to customize the layout process or you need to intervene in that behavior, you can use Text Kit. For smaller amounts of text and special needs requiring custom solutions, you can use alternative, lower-level technologies, as described in Lower Level Text-Handling Technologies.\n\nText Kit is a set of classes and protocols in the UIKit framework providing high-quality typographical services that enable apps to store, lay out, and display text with all the characteristics of fine typesetting, such as kerning, ligatures, line breaking, and justification."
        self.label.userInteractionEnabled = true
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.label)
        
        if (self.showConsole) {
            self.debugConsole = DebugConsole()
            self.debugConsole.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.debugConsole)
            
            self.labelSelectionDidChange()
        }
        
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(didDoubleTapButton))
        
        self.button = UIButton(type:.Custom)
        self.button.addGestureRecognizer(doubleTap)
        self.button.addTarget(self, action: #selector(didTapButton), forControlEvents: .TouchUpInside)
        self.button.alpha = 0.8
        self.button .setBackgroundImage(UIImage(named: "blue_circle"), forState: .Normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.button)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        let metrics = ["margin": margin, "buttonMargin": -60.0]
        var views: [String: AnyObject] = ["label": self.label, "button": self.button]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[label]-margin-|", options: [], metrics: metrics, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(==175.0)]-buttonMargin-|", options: [], metrics: metrics, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(==175.0)]-buttonMargin-|", options: [], metrics: metrics, views: views))
        
        if (self.showConsole) {
            views["debugConsole"] = self.debugConsole
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[debugConsole]-margin-|", options: [], metrics: metrics, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[label]-margin-[debugConsole]-margin-|", options: [], metrics: metrics, views: views))
        } else {
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-margin-[label]-margin-|", options: [], metrics: metrics, views: views))
        }
    }
    
    var showConsole: Bool {
        get {
            return self.mode.contains(.ShowConsole)
        }
    }
    
    func didTapButton() {
        self.label.appendPreSelectionToSelection()
    }
    
    func didDoubleTapButton() {
        self.label.clearSelection()
    }
}

extension ViewController: HighlightLabelDelegate {
    func labelSelectionDidChange() {
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