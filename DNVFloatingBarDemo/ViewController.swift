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
        
        let searchBarItem = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(buttonTapped(button:)))
        let attachBarItem = UIBarButtonItem(image: UIImage(named: "Attach"), style: .plain, target: self, action: #selector(buttonTapped(button:)))
        let textBarItem = UIBarButtonItem(image: UIImage(named: "Generic Text"), style: .plain, target: self, action: #selector(buttonTapped(button:)))
        bar.items = [searchBarItem, attachBarItem, textBarItem];
        bar.backgroundColor = .brown
        view.addSubview(bar)
    }

    override func viewWillLayoutSubviews() {
//        bar.setNeedsLayout()
        super.viewWillLayoutSubviews()
    }
    
    func buttonTapped(button: UIButton) {
//        print(button)
        button.backgroundColor = (button.backgroundColor == nil) ? .darkGray : nil
    }
}

