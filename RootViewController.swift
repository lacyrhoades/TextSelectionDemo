//
//  RootViewController.swift
//  TextSelection
//
//  Created by Lacy Rhoades on 5/15/16.
//  Copyright © 2016 Ink & Switch. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // let vc = LabelBasedViewController()
        let vc = TextBasedViewController()
        
        self.presentViewController(vc, animated: true) {
            // done
        }
    }
}