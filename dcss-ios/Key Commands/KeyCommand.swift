//
//  KeyCommand.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/27/21.
//

typealias JavascriptKeycode = Int

enum KeyCommand: JavascriptKeycode, CaseIterable {
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
