//
//  DNVFloatingBarItem.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit

class DNVFloatingBarItem: UIBarButtonItem {

//    var target: AnyObject?
//    var action: Selector?
    
    convenience init(image: UIImage?, target: Any?, action: Selector?) {
        self.init()
        self.image = image
        self.target = target as AnyObject?
        self.action = action
    }
}
