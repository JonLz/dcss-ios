//
//  JSBridge.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/26/21.
//

import Foundation

struct JSBridge {
    static func sendKeyPressed(_ key: String) -> String {
        return """
            var press = jQuery.Event("keypress");
            press.which = "\(key)".charCodeAt(0);
            $("body").trigger(press);
        """
    }
    
    static func sendControlKeyPressed(with key: String) -> String {
        // uppercasing the key as all control commands check uppercased keys or numbers
        // originalEvent must be set to avoid a js error due to how it checks jQuery
        return """
            var press = jQuery.Event("keydown");
            press.which = "\(key)".toUpperCase().charCodeAt(0);
            press.ctrlKey = true;
            press.originalEvent = {};
            $('body').trigger(press);
        """
    }
}
