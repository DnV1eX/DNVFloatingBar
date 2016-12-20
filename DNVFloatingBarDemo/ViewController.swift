//
//  ViewController.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let bar = DNVFloatingBar()
    
    var searchBarButtonItem, attachBarButtonItem, textBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "LICENSE", ofType: "txt") {
            textView.text = try? String(contentsOfFile: path)
        }
        
        let showHideBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(showHideButtonTapped(item:)))
        navigationItem.leftBarButtonItem = showHideBarButtonItem
        
        let mode0BarButtonItem = UIBarButtonItem(title: "0", style: .plain, target: self, action: #selector(switchModeButtonTapped(item:)))
        let mode1BarButtonItem = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(switchModeButtonTapped(item:)))
        let mode2BarButtonItem = UIBarButtonItem(title: "2", style: .plain, target: self, action: #selector(switchModeButtonTapped(item:)))
        let mode3BarButtonItem = UIBarButtonItem(title: "3", style: .plain, target: self, action: #selector(switchModeButtonTapped(item:)))
        navigationItem.rightBarButtonItems = [mode3BarButtonItem, mode2BarButtonItem, mode1BarButtonItem, mode0BarButtonItem]
        
        searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(menuButtonTapped(item:)))
        searchBarButtonItem.title = "Search"
        searchBarButtonItem.tintColor = .red
        attachBarButtonItem = UIBarButtonItem(image: UIImage(named: "Attach"), style: .plain, target: self, action: #selector(menuButtonTapped(item:)))
        attachBarButtonItem.title = "Attach"
        attachBarButtonItem.tintColor = .green
        textBarButtonItem = UIBarButtonItem(image: UIImage(named: "Generic Text"), style: .plain, target: self, action: #selector(menuButtonTapped(item:)))
        textBarButtonItem.title = "Font"
        textBarButtonItem.tintColor = .blue
        bar.items = [searchBarButtonItem, attachBarButtonItem, textBarButtonItem];
        bar.backgroundColor = .brown
        view.addSubview(bar)
    }

    func showHideButtonTapped(item: UIBarButtonItem) {
        textView.resignFirstResponder()
    }
    
    func switchModeButtonTapped(item: UIBarButtonItem) {
        switch item.title {
        case "0"?:
//            bar.items = nil
            bar.setItems(nil, animated: true)
        case "1"?:
//            bar.items = [searchBarButtonItem];
            bar.setItems([self.searchBarButtonItem], animated: true)
        case "2"?:
//            bar.items = [searchBarButtonItem, textBarButtonItem];
            bar.setItems([self.searchBarButtonItem, self.textBarButtonItem], animated: true)
        case "3"?:
            bar.setItems([self.searchBarButtonItem, self.attachBarButtonItem, self.textBarButtonItem], animated: true)
        default:
            break
        }
    }
    
    func menuButtonTapped(item: UIBarButtonItem) {
//        print(item)
        
        let alertController = UIAlertController(title: item.title, message: nil, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        alertController.popoverPresentationController?.barButtonItem = item
        present(alertController, animated: true, completion: nil)
    }
}

