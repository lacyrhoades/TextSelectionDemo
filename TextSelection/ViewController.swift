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
    var debugConsole: DebugConsole!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.mode.append(.ShowConsole)
        
        self.label = HighlightLabel()
        self.label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        self.label.userInteractionEnabled = true
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.label)
        
        if (self.showConsole) {
            self.debugConsole = DebugConsole()
            self.debugConsole.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.debugConsole)
        }
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        let metrics = ["margin": margin]
        var views: [String: AnyObject] = ["label": self.label]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[label]-margin-|", options: [], metrics: metrics, views: views))
        
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
}

