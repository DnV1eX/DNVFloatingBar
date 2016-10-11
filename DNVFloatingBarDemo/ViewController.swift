//
//  ViewController.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bar = DNVFloatingBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarItem = DNVFloatingBarItem(image: UIImage(named: "Search"), target: nil, action: nil)
        let attachBarItem = DNVFloatingBarItem(image: UIImage(named: "Attach"), target: nil, action: nil)
        let textBarItem = DNVFloatingBarItem(image: UIImage(named: "Generic Text"), target: nil, action: nil)
        bar.items = [searchBarItem, attachBarItem, textBarItem];
        bar.backgroundColor = .brown
        view.addSubview(bar)
    }

    override func viewWillLayoutSubviews() {
        bar.setNeedsLayout()
        super.viewWillLayoutSubviews()
    }
}

