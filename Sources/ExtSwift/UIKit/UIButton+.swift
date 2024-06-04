//
//  UIButton+.swift
//  ExtSwift
//
//  Created by Míng on 2024-04-08.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if canImport(UIKit)
import UIKit

// MARK: - set backgroundColor for state

extension UIButton {
    public func setBackgroundColor(_ color: UIColor?, for state: State) {
        setImage(color.transform { UIImage.image(with: $0) }, for: state)
    }
}

// MARK: - set attributes for state and possible states

extension UIButton {
    
    private func with(_ state: State, possible states: [State], closure: (_ state: State) -> Void) {
        closure(state)
        for each in states {
            let merged = State(rawValue: state.rawValue | each.rawValue)
            if merged != state {
                closure(merged)
            }
        }
    }
    
    public func setTitle(_ title: String?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitle(title, for: $0) }
    }
    
    public func setTitleColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitleColor(color, for: $0) }
    }
    
    public func setTitleShadowColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitleShadowColor(color, for: $0) }
    }
    
    public func setAttributedTitle(_ title: NSAttributedString?, for state: State, possible states: State...) {
        with(state, possible: states) { setAttributedTitle(title, for: $0) }
    }
    
    public func setImage(_ image: UIImage?, for state: State, possible states: State...) {
        with(state, possible: states) { setImage(image, for: $0) }
    }
    
    public func setBackgroundColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setBackgroundColor(color, for: $0) }
    }
    
    public func setBackgroundImage(_ image: UIImage?, for state: State, possible states: State...) {
        with(state, possible: states) { setBackgroundImage(image, for: $0) }
    }
    
    public func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: State, possible states: State...) {
        with(state, possible: states) { setPreferredSymbolConfiguration(configuration, forImageIn: $0) }
    }
}

// MARK: - enabling kvo for state

extension UIControl {
    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let set = super.keyPathsForValuesAffectingValue(forKey: key)
        guard key == #keyPath(UIControl.state) else { return set }
        return set.union([
            #keyPath(UIControl.isEnabled),
            #keyPath(UIControl.isSelected),
            #keyPath(UIControl.isHighlighted)
        ])
    }
}

// MARK: - disable for seconds

extension UIControl {
    
    public func disable(for seconds: TimeInterval, then callback: @escaping (_ control: UIControl) -> Void = { $0.isEnabled = true }) {
        guard seconds > 0.0 else { return }
        
        if let prevWrapper = objc_getAssociatedObject(self, &AssociatedObject_kvoHandlerWrapper) as? HandlerWrapper {
            prevWrapper.handle(cancel: true)
        }
        
        isEnabled = false
        
        let wrapper = HandlerWrapper { [weak self] wrapper, isCancelled in
            guard let self else { return }
            NSObject.cancelPreviousPerformRequests(withTarget: wrapper)
            removeObserver(wrapper, forKeyPath: #keyPath(UIControl.isEnabled), context: &AssociatedObject_kvoContext)
            objc_setAssociatedObject(self, &AssociatedObject_kvoHandlerWrapper, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // isCancelled: false - called from afterDelay, true - called from KVO or prevWrapper
            if !isCancelled {
                callback(self)
            }
        }
        
        objc_setAssociatedObject(self, &AssociatedObject_kvoHandlerWrapper, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addObserver(wrapper, forKeyPath: #keyPath(UIControl.isEnabled), options: [.old, .new], context: &AssociatedObject_kvoContext)
        wrapper.perform(#selector(HandlerWrapper.handle), with: nil, afterDelay: seconds)
    }
}

fileprivate var AssociatedObject_kvoContext: UInt8 = 0
fileprivate var AssociatedObject_kvoHandlerWrapper: UInt8 = 0

@objc
fileprivate class HandlerWrapper: NSObject {
    
    private var handler: ((_ wrapper: HandlerWrapper, _ isCancelled: Bool) -> Void)?
    
    init(handler: @escaping (_ wrapper: HandlerWrapper, _ isCancelled: Bool) -> Void) { self.handler = handler }
    
    @objc func handle(cancel: Bool = false) {
        if let handler {
            self.handler = nil
            handler(self, cancel)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &AssociatedObject_kvoContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == #keyPath(UIControl.isEnabled) {
            handle(cancel: true)
        }
    }
}
#endif
