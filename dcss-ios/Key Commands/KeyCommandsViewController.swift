//
//  KeyCommandsViewController.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

import UIKit
import SwiftUI

final class KeyCommandsViewController: UIHostingController<KeyCommandsView> {

    init(onKeyCommandTapped: @escaping (KeyCommand) -> Void, onKeyboardTapped: @escaping () -> Void) {
        let view = KeyCommandsView(onKeyCommandTapped: onKeyCommandTapped, onKeyboardTapped: onKeyboardTapped)
        super.init(rootView: view)
        self.view.backgroundColor = UIColor.black
        ignoreKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // adapted from: https://steipete.com/posts/disabling-keyboard-avoidance-in-swiftui-uihostingcontroller/
    private func ignoreKeyboard() {
        guard let viewClass = object_getClass(view) else { return }
        
        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
            
            if let method = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
                let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
                class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"),
                                imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method))
            }
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
}
