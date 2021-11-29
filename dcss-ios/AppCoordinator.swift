//
//  AppCoordinator.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/28/21.
//

import Foundation
import UIKit

final class AppCoordinator: ServerSelectionDelegate {
    
    private(set) lazy var rootViewController: UIViewController = {
        ServerSelectionViewController(delegate: self)
    }()
}

// MARK: - ServerSelectionDelegate

extension AppCoordinator {
    func didSelectServer(serverURL: URL) {
        let webVC = WebContainerViewController(serverURL: serverURL)
        webVC.modalPresentationStyle = .fullScreen
        rootViewController.present(webVC, animated: true)
    }
}
