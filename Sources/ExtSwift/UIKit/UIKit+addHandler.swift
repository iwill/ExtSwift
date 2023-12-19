//
//  UIKit+addHandler.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-19.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

private var AssociatedObject_handlerWrappers: UInt8 = 0

// MARK: UIControl

fileprivate class EventHandlerWrapper: Equatable {
    private let handler: (_ sender: UIControl, UIControl.Event) -> Void
    let event: UIControl.Event
    init(event:UIControl.Event, handler: @escaping (_ sender: UIControl, UIControl.Event) -> Void) {
        self.event = event
        self.handler = handler
    }
    @objc func action(with sender: UIControl) {
        handler(sender, event)
    }
    static func == (lhs: EventHandlerWrapper, rhs: EventHandlerWrapper) -> Bool {
        return lhs === rhs
    }
}

public extension ES where Base: UIControl {
    
    @discardableResult
    func addHandler(for events: UIControl.Event, _ handler: @escaping (UIControl, UIControl.Event) -> Void) -> Any {
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [EventHandlerWrapper] ?? []
        var targets: [EventHandlerWrapper] = []
        
        var rawValue: UInt = 1
        while rawValue <= UIControl.Event.allEvents.rawValue {
            let event = UIControl.Event(rawValue: rawValue)
            if events.contains(event) {
                let wrapper = EventHandlerWrapper(event: event, handler: handler)
                _base.addTarget(wrapper, action: #selector(EventHandlerWrapper.action(with:)), for: event)
                wrappers.append(wrapper)
                targets.append(wrapper)
            }
            rawValue <<= 1
        }
        
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return targets.count == 1 ? targets.first! : targets
    }
    
    func removeHandler(with target: Any, for events: UIControl.Event) {
        if let targets = target as? [EventHandlerWrapper] {
            for target in targets {
                removeHandler(with: target, for: events)
            }
            return
        }
        guard let wrapper = target as? EventHandlerWrapper else {
            return
        }
        if events.contains(wrapper.event) {
            _base.removeTarget(wrapper, action: #selector(EventHandlerWrapper.action(with:)), for: events) // events - NOT wrapper.event
            var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [EventHandlerWrapper] ?? []
            wrappers.removeAll { $0 == wrapper }
            objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers.isEmpty ? nil : wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func removeHandlers(for events: UIControl.Event) {
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [EventHandlerWrapper] ?? []
        for wrapper in wrappers {
            if events.contains(wrapper.event) {
                _base.removeTarget(wrapper, action: #selector(EventHandlerWrapper.action(with:)), for: events) // events - NOT wrapper.event
                wrappers.removeAll { $0 == wrapper }
            }
        }
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers.isEmpty ? nil : wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func removeAllHandlers() {
        removeHandlers(for: UIControl.Event.allEvents)
    }
}

public extension ES where Base: UIButton {
    
    @discardableResult
    func addHandler(_ handler: @escaping (Base) -> Void) -> Any {
        addHandler(for: .touchUpInside) { sender, event in
            handler(sender as! Base)
        }
    }
    
    func removeHandler(with target: Any) {
        removeHandler(with: target, for: .touchUpInside)
    }
}

// MARK: UIBarButtonItem

fileprivate class UIBarButtonItemActionHandlerWrapper: Equatable {
    private let handler: (_ sender: UIBarButtonItem) -> Void
    init(_ handler: @escaping (_ sender: UIBarButtonItem) -> Void) {
        self.handler = handler
    }
    func action(with sender: UIBarButtonItem) {
        handler(sender)
    }
    static func == (lhs: UIBarButtonItemActionHandlerWrapper, rhs: UIBarButtonItemActionHandlerWrapper) -> Bool {
        return lhs === rhs
    }
}

fileprivate extension UIBarButtonItem {
    @objc func _es_action(with sender: UIBarButtonItem) {
        let wrappers = objc_getAssociatedObject(self, &AssociatedObject_handlerWrappers) as? [UIBarButtonItemActionHandlerWrapper] ?? []
        for wrapper in wrappers {
            wrapper.action(with: sender)
        }
    }
}

public extension ES where Base: UIBarButtonItem {
    
    func addHandler(_ handler: @escaping (UIBarButtonItem) -> Void) -> Any {
        _base.target = _base
        _base.action = #selector(UIBarButtonItem._es_action(with:))
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [UIBarButtonItemActionHandlerWrapper] ?? []
        let wrapper = UIBarButtonItemActionHandlerWrapper(handler)
        wrappers.append(wrapper)
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return wrapper
    }
    
    func removeHandler(with target: Any) {
        guard let wrapper = target as? UIBarButtonItemActionHandlerWrapper else {
            return
        }
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [UIBarButtonItemActionHandlerWrapper] ?? []
        wrappers.removeAll { $0 == wrapper }
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers.isEmpty ? nil : wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func removeAllHandlers() {
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: UIGestureRecognizer

private class UIGestureRecognizerActionHandlerWrapper: Equatable {
    private let handler: (_ sender: UIGestureRecognizer) -> Void
    init(_ handler: @escaping (_ sender: UIGestureRecognizer) -> Void) {
        self.handler = handler
    }
    @objc func action(with sender: UIGestureRecognizer) {
        handler(sender)
    }
    static func == (lhs: UIGestureRecognizerActionHandlerWrapper, rhs: UIGestureRecognizerActionHandlerWrapper) -> Bool {
        return lhs === rhs
    }
}

public extension ES where Base: UIGestureRecognizer {
    
    func addHandler(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Any {
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [UIGestureRecognizerActionHandlerWrapper] ?? []
        let wrapper = UIGestureRecognizerActionHandlerWrapper(handler)
        _base.addTarget(wrapper, action: #selector(UIGestureRecognizerActionHandlerWrapper.action(with:)))
        wrappers.append(wrapper)
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return wrapper
    }
    
    func removeHandler(with target: Any) {
        guard let wrapper = target as? UIGestureRecognizerActionHandlerWrapper else {
            return
        }
        _base.removeTarget(wrapper, action: #selector(UIGestureRecognizerActionHandlerWrapper.action(with:)))
        var wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [UIGestureRecognizerActionHandlerWrapper] ?? []
        wrappers.removeAll { $0 == wrapper }
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, wrappers.isEmpty ? nil : wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func removeAllHandlers() {
        let wrappers = objc_getAssociatedObject(_base, &AssociatedObject_handlerWrappers) as? [UIGestureRecognizerActionHandlerWrapper] ?? []
        for wrapper in wrappers {
            _base.removeTarget(wrapper, action: #selector(UIGestureRecognizerActionHandlerWrapper.action(with:)))
        }
        objc_setAssociatedObject(_base, &AssociatedObject_handlerWrappers, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
