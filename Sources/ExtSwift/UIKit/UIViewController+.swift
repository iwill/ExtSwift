//
//  UIViewController+.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-21.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

public extension UIViewController {
    
    func add(child controller: UIViewController) {
        add(child: controller, superview: view)
    }
    
    func add(child controller: UIViewController, superview: UIView) {
        /* The addChildViewController: method automatically calls the willMoveToParentViewController: method
         * of the view controller to be added as a child before adding it.
         */
        addChild(controller) // 1
        superview.addSubview(controller.view) // 2
        controller.didMove(toParent: self) // 3
    }
    
    func add(child controller: UIViewController, superview: UIView, at index: NSInteger) {
        addChild(controller) // 1
        superview.insertSubview(controller.view, at: index) // 2
        controller.didMove(toParent: self) // 3
    }
    
    func add(child controller: UIViewController, superview: UIView, belowSubview siblingSubview: UIView) {
        addChild(controller) // 1
        superview.insertSubview(controller.view, belowSubview: siblingSubview) // 2
        controller.didMove(toParent: self) // 3
    }
    
    func add(child controller: UIViewController, superview: UIView, aboveSubview siblingSubview: UIView) {
        addChild(controller) // 1
        superview.insertSubview(controller.view, aboveSubview: siblingSubview) // 2
        controller.didMove(toParent: self) // 3
    }
    
    func add(child controller: UIViewController, addSubview: (_ parentView: UIView, _ childView: UIView) -> Void) {
        addChild(controller) // 1
        addSubview(view, controller.view) // 2
        controller.didMove(toParent: self) // 3
    }
    
    func removeFromParentViewControllerAndSuperiew() {
        willMove(toParent: nil) // 1
        /* The removeFromParentViewController method automatically calls the didMoveToParentViewController: method
         * of the child view controller after it removes the child.
         */
        if isViewLoaded { view.removeFromSuperview() } // 2
        removeFromParent() // 3
    }
}

public extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return self.viewControllers.first
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    @discardableResult
    func popViewController(animated: Bool, completion: @escaping () -> Void) -> UIViewController? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let viewController = popViewController(animated: animated)
        CATransaction.commit()
        return viewController
    }
    
    @discardableResult
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let viewControllers = popToViewController(viewController, animated: animated)
        CATransaction.commit()
        return viewControllers
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let viewControllers = popToRootViewController(animated: animated)
        CATransaction.commit()
        return viewControllers
    }
}
