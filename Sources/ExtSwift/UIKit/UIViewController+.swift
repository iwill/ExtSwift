//
//  UIViewController+.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-21.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

public extension UIViewController {
    
    func addChild(_ childController: UIViewController) {
        addChild(childController, superview: view)
    }
    
    func addChild(_ childController: UIViewController, superview: UIView) {
        /* The addChildViewController: method automatically calls the willMoveToParentViewController: method
         * of the view controller to be added as a child before adding it.
         */
        addChild(childController) // 1
        superview.addSubview(childController.view) // 2
        childController.didMove(toParent: self) // 3
    }
    
    func addChild(_ childController: UIViewController, superview: UIView, at index: NSInteger) {
        addChild(childController) // 1
        superview.insertSubview(childController.view, at: index) // 2
        childController.didMove(toParent: self) // 3
    }
    
    func addChild(_ childController: UIViewController, superview: UIView, belowSubview siblingSubview: UIView) {
        addChild(childController) // 1
        superview.insertSubview(childController.view, belowSubview: siblingSubview) // 2
        childController.didMove(toParent: self) // 3
    }
    
    func addChild(_ childController: UIViewController, superview: UIView, aboveSubview siblingSubview: UIView) {
        addChild(childController) // 1
        superview.insertSubview(childController.view, aboveSubview: siblingSubview) // 2
        childController.didMove(toParent: self) // 3
    }
    
    func addChild(_ childController: UIViewController, addSubview: (_ parentView: UIView, _ childView: UIView) -> Void) {
        addChild(childController) // 1
        addSubview(view, childController.view) // 2
        childController.didMove(toParent: self) // 3
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
