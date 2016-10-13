//
//  DNVFloatingBar.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit

public class DNVFloatingBar: UIView {

    public var items: [UIBarButtonItem]? {
        didSet {
            for button in clipView.subviews where button is UIButton {
                button.removeFromSuperview()
            }
            if let items = items {
                for item in items {
                    let button = UIButton(type: .custom)
                    button.setImage(item.image, for: .normal)
                    clipView.addSubview(button)
                    if let action = item.action {
                        button.addTarget(item.target, action: action, for: .touchUpInside)
                    }
                }
            }
            setNeedsLayout()
        }
    }
    
    public var height: CGFloat {
        didSet { setNeedsLayout() }
    }
    
    public var offset: CGPoint {
        didSet { setNeedsLayout() }
    }
    
    public var padding: CGFloat {
        didSet { setNeedsLayout() }
    }
    
    private var keyboardHeight: CGFloat = 0
    private let clipView = UIView()
    
    init() {
        height = 40
        offset = CGPoint(x: 20, y: 20)
        padding = 5
        
        super.init(frame: CGRect(x: 0, y: 0, width: height + padding * 2, height: height))
        
        backgroundColor = .white
        
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray.cgColor
        
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1.5
        layer.shadowColor = UIColor.gray.cgColor
        
        autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        
        clipView.frame = bounds
        clipView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        clipView.clipsToBounds = true
        addSubview(clipView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let superview = superview else { return }
        
        frame.size = CGSize(width: height * CGFloat(items?.count ?? 0) + padding * 2, height: height)
        center = CGPoint(x: superview.bounds.width - offset.x - frame.width / 2, y: superview.bounds.height - keyboardHeight - offset.y - frame.height / 2)
        
        layer.cornerRadius = height / 2
        clipView.layer.cornerRadius = layer.cornerRadius
        
        for (index, button) in clipView.subviews.enumerated() where button is UIButton {
            button.frame = CGRect(x: height * CGFloat(index) + padding, y: 0, width: height, height: height)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        }
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
}
