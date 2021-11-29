//
//  UserDefaults+Extensions.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/29/21.
//

import Foundation

extension UserDefaults {
    private static let defaultServerURLKey = "com.dcss-ios.defaultServerKey"
    @objc var defaultServerURL: URL? {
        get {
            if let urlString = value(forKey: Self.defaultServerURLKey) as? String {
                return URL(string: urlString)
            } else {
                return nil
            }
        }
        set {
            set(newValue?.absoluteString, forKey: Self.defaultServerURLKey)
            synchronize()
        }
    }
}
