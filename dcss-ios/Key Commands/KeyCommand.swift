//
//  KeyCommand.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

protocol KeyCommand {
    var executableJavascript: String { get }
    var id: String { get }
    var symbolName: String { get }
}

enum KeypressCommand: String, CaseIterable, KeyCommand {
    case o = "o" // auto-explore
    case five = "5" // rest
    case u = "u" // north-east
    case n = "n" // south-east
    case b = "b" // south-west
    case y = "y" // north-west
    
    var executableJavascript: String {
        JSBridge.sendKeyPressed(rawValue)
    }
    
    var id: String {
        "KeypressCommand_\(rawValue)"
    }
    
    var symbolName: String {
        switch self {
        case .five:
            return "hand.raised"
        case .o:
            return "arrow.rectanglepath"
        case .u:
            return "arrow.up.right"
        case .n:
            return "arrow.down.right"
        case .b:
            return "arrow.down.left"
        case .y:
            return "arrow.up.left"
        }
    }
}

typealias JavascriptKeycode = Int

enum KeydownCommand: JavascriptKeycode, CaseIterable, KeyCommand {
    case tab = 9 // auto-attack
    case escape = 27
    case leftArrow = 37
    case upArrow = 38
    case rightArrow = 39
    case downArrow = 40
    
    var executableJavascript: String {
        JSBridge.sendKeydownPressed(rawValue)
    }
    
    var id: String {
        "KeydownCommand_\(rawValue)"
    }

    var symbolName: String {
        switch self {
        case .tab:
            return "bolt"
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

enum KeypressWithControlCommand: String, CaseIterable, KeyCommand {
    case f = "f" // find

    var executableJavascript: String {
        JSBridge.sendControlKeyPressed(with: rawValue)
    }
    
    var id: String {
        "KeypressWithControlCommand_\(rawValue)"
    }

    var symbolName: String {
        switch self {
        case .f:
            return "doc.text.magnifyingglass"
        }
    }
}

struct ReturnKeypressCommand: KeyCommand {
    let id = "ReturnKeyPressCommand"
    let executableJavascript = """
        var press = jQuery.Event("keypress");
        press.which = 13;
        $("body").trigger(press);
    """
    let symbolName: String = "return"
}
