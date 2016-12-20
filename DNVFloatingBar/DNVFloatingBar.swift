//
//  DNVFloatingBar.swift
//  DNVFloatingBar
//
//  Created by Alexey Demin on 2016-10-07.
//  Copyright © 2016 Alexey Demin. All rights reserved.
//

import UIKit


public class DNVFloatingBar: UIView {

    private var buttonsByItems = [UIBarButtonItem: UIButton]()
    
    private var deferredRemoval = false
    
    private func frameForButton(atIndex index: Int, buttonCount count: Int) -> CGRect {
        return CGRect(x: padding + (clipView.bounds.width - padding * 2 - height) / CGFloat(max(1, count - 1)) * CGFloat(index), y: 0, width: height, height: height)
    }
    
    public var items: [UIBarButtonItem]? {
        didSet {
            if let items = items {
                for (index, item) in items.enumerated() where buttonsByItems[item] == nil {
                    let button = UIButton(type: .custom)
                    button.setImage(item.image, for: .normal)
                    button.frame = frameForButton(atIndex: index, buttonCount: items.count)
                    clipView.addSubview(button)
//                    object_setIvar(item, class_getInstanceVariable(type(of: item), ("_view" as NSString).utf8String), button)
                    item.customView = button
                    button.addTarget(self, action: #selector(onTap(button:event:)), for: .touchUpInside)
                    buttonsByItems[item] = button
                    if deferredRemoval {
                        button.alpha = 0
                    }
                }
            }
            if let oldItems = oldValue, !deferredRemoval {
                for item in oldItems where items == nil || !items!.contains(item) {
                    buttonsByItems[item]?.removeFromSuperview()
                    buttonsByItems[item] = nil
                }
            }
            setNeedsLayout()
        }
    }
    
    public func setItems(_ items: [UIBarButtonItem]?, animated: Bool) {
        UIView.setAnimationsEnabled(animated)
        let oldValue = self.items
        deferredRemoval = true
        self.items = items
        deferredRemoval = false
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration), delay: 0, options: .curveEaseOut, animations: {
            for (item, button) in self.buttonsByItems {
                if let items = items, items.contains(item) {
                    button.alpha = 1
                }
                else {
                    button.alpha = 0
                }
            }
            self.layoutIfNeeded()
            if let oldItems = oldValue {
                for item in oldItems where items == nil || !items!.contains(item) {
                    self.buttonsByItems[item]?.frame = self.frameForButton(atIndex: oldItems.index(of: item) ?? 0, buttonCount: oldItems.count)
                }
            }
            }, completion: { _ in
                if let oldItems = oldValue {
                    for item in oldItems where items == nil || !items!.contains(item) {
                        self.buttonsByItems[item]?.removeFromSuperview()
                        self.buttonsByItems[item] = nil
                    }
                }
            })
        UIView.setAnimationsEnabled(true)
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
        
        frame.size = CGSize(width: height * CGFloat(max(1, items?.count ?? 0)) + padding * 2, height: height)
        center = CGPoint(x: superview.bounds.width - offset.x - frame.width / 2, y: superview.bounds.height - keyboardHeight - offset.y - frame.height / 2)
        
        layer.cornerRadius = height / 2
        clipView.layer.cornerRadius = layer.cornerRadius
        
        if let items = items {
            for (index, item) in items.enumerated() {
                if let button = buttonsByItems[item] {
                    button.frame = frameForButton(atIndex: index, buttonCount: items.count)//CGRect(x: height * CGFloat(index) + padding, y: 0, width: height, height: height)
                    button.backgroundColor = item.tintColor
                }
            }
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
    
    
    @objc private func onTap(button: UIButton, event: UIEvent) {
        
        guard let item = buttonsByItems.first(where: { $1 == button })?.key, let action = item.action else { return }
        
        UIApplication.shared.sendAction(action, to: item.target, from: item, for: event)
    }
}
