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
}
