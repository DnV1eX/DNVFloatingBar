//
//  DNVFloatingBar.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit

class DNVFloatingBar: UIView {

    var items: [DNVFloatingBarItem]? {
        didSet {
            for button in subviews where button is UIButton {
                button.removeFromSuperview()
            }
            if let items = items {
                for item in items {
                    let button = UIButton(type: .custom)
                    button.setImage(item.image, for: .normal)
                    addSubview(button)
                    if let action = item.action {
                        button.addTarget(item.target, action: action, for: .touchUpInside)
                    }
                }
            }
            setNeedsLayout()
        }
    }
    
    var height: CGFloat = 40
    
    var barInsets: UIEdgeInsets
    
    private var isKeyboardShown = false
    private var keyboardHeight: CGFloat = 0
    
    init() {
        barInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        super.init(frame: CGRect(x: 0, y: 0, width: height * 2, height: height))
        
        backgroundColor = .white
        
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray.cgColor
        
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1.5
        layer.shadowColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let superview = superview else { return }
        
        frame.size = CGSize(width: height * CGFloat(items?.count ?? 0) + height / 2, height: height)
        center = CGPoint(x: superview.bounds.width - barInsets.right - frame.width / 2, y: superview.bounds.height - keyboardHeight - barInsets.bottom - frame.height / 2)
        layer.cornerRadius = height / 2
        
        for (index, button) in subviews.enumerated() where button is UIButton {
            button.frame = CGRect(x: height * CGFloat(index) + height / 4, y: 0, width: height, height: height)
        }
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        isKeyboardShown = true
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIViewAnimationCurve(rawValue: Int($0))! } ?? UIViewAnimationCurve.linear
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect()
        keyboardHeight = superview?.convert(keyboardFrame, from: window).intersection(superview?.bounds ?? CGRect()).height ?? 0
        
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))], animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        isKeyboardShown = false
    }
}
