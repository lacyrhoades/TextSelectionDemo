//
//  RootViewController.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/15/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var navigationViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        var button = self.button(CGRectMake(0, 100, 300, 48))
        button.tag = 1
        button.setTitle("Full Custom UITextInput", forState: .Normal)
        button.enabled = false
        view.addSubview(button)
        button = self.button(CGRectMake(0, 200, 300, 48))
        button.tag = 2
        button.setTitle("Hacked UITextView", forState: .Normal)
        view.addSubview(button)
        button = self.button(CGRectMake(0, 300, 300, 48))
        button.tag = 3
        button.setTitle("Hacked UILabel", forState: .Normal)
        view.addSubview(button)
    }
    
    func button(frame: CGRect) -> UIButton {
        let button = UIButton(type: .System)
        button.frame = frame
        button.center.x = self.view.frame.width / 2.0
        button.addTarget(self, action: #selector(didTapButton), forControlEvents: .TouchUpInside)
        return button
    }
    
    func didTapButton(button: UIButton) {
        switch (button.tag) {
        case 1:
            let vc = TextBasedViewController()
            self.navigationViewController.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = TextBasedViewController()
            self.navigationViewController.pushViewController(vc, animated: true)
            break
        default:
            let vc = LabelBasedViewController()
            self.navigationViewController.pushViewController(vc, animated: true)
            break
        }
    }
}

class RootViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = MenuViewController()
        vc.navigationViewController = self
        self.pushViewController(vc, animated: false)
    }
}