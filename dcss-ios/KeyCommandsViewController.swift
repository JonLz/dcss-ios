//
//  KeyCommandsViewController.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

import UIKit
import SwiftUI

typealias JavascriptKeycode = Int

enum KeydownCommand: JavascriptKeycode, CaseIterable {
    case escape = 27
    case leftArrow = 37
    case upArrow = 38
    case rightArrow = 39
    case downArrow = 40
    
    var symbolName: String {
        switch self {
        case .escape:
            return "escape"
        case .leftArrow:
            return "arrow.left"
        case .upArrow:
            return "arrow.up"
        case .rightArrow:
            return "arrow.right"
        case .downArrow:
            return "arrow.down"
        }
    }
}

final class KeyCommandsViewController: UIHostingController<KeyCommandsView> {

    init(onKeyCommandTapped: @escaping (KeydownCommand) -> Void) {
        super.init(rootView: KeyCommandsView(onKeyCommandTapped: onKeyCommandTapped))
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

struct KeyCommandsView: View {
    
    let onKeyCommandTapped: (KeydownCommand) -> Void
    
    var body: some View {
        ForEach(KeydownCommand.allCases, id: \.rawValue) { keyCommand in
            Image(systemName: keyCommand.symbolName)
                .frame(width: 24, height: 24, alignment: .center)
                .padding(.bottom, 4)
                .onTapGesture {
                    onKeyCommandTapped(keyCommand)
                }
        }
    }
}
