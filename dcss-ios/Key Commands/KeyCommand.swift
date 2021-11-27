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
        }
    }
}

typealias JavascriptKeycode = Int

enum KeydownCommand: JavascriptKeycode, CaseIterable, KeyCommand {
    case tab = 9 // auto-attack
    
    case leftArrow = 37
    case upArrow = 38
    case rightArrow = 39
    case downArrow = 40
    case escape = 27
    
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
