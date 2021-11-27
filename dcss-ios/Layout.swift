//
//  Layout.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/25/21.
//

import Foundation
import UIKit

// MARK: - UI Utilities

extension UIView {
    @discardableResult
    func addAsSubview(to view: UIView) -> UIView {
        view.addSubview(self)
        return self
    }
}

// MARK: - Constraint helpers

extension UIView {
    /// Constrains the view to its superview's edges using the safeAreaLayoutGuide for the topAnchor
    func constrainToSuperview() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
