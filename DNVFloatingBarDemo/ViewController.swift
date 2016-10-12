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
        
        let searchBarItem = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(buttonTapped(item:)))
        let attachBarItem = UIBarButtonItem(image: UIImage(named: "Attach"), style: .plain, target: self, action: #selector(buttonTapped(item:)))
        let textBarItem = UIBarButtonItem(image: UIImage(named: "Generic Text"), style: .plain, target: self, action: #selector(buttonTapped(item:)))
        bar.items = [searchBarItem, attachBarItem, textBarItem];
        bar.backgroundColor = .brown
        view.addSubview(bar)
    }

    override func viewWillLayoutSubviews() {
        bar.setNeedsLayout()
        super.viewWillLayoutSubviews()
    }
    
    func buttonTapped(item: UIBarButtonItem) {
        print(item)
    }
}

