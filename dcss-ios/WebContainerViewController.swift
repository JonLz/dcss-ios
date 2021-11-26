//
//  WebContainerViewController.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/25/21.
//

import UIKit
import WebKit

class WebContainerViewController: UIViewController, UITextFieldDelegate {

    let webView = WKWebView()
    let inputButton = UIButton()
    let invisibleTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        
        invisibleTextField.delegate = self
        
        let url = URL(string: "https://crawl.kelbi.org/#lobby")!
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func sendCommand() {
        invisibleTextField.becomeFirstResponder()
        
        let webViewContentOffset = webView.scrollView.contentOffset.y
        let offset = CGPoint(x: 0, y: webViewContentOffset + 100)
        webView.scrollView.setContentOffset(offset, animated: true)
    }
    
    private func layoutViews() {
        webView
            .addAsSubview(to: view)
            .constrainToSuperview()
        
        inputButton
            .addAsSubview(to: view)
            .alignHorizontalEdgesToSuperview()
        NSLayoutConstraint.activate([
            inputButton.heightAnchor.constraint(equalToConstant: 50),
            inputButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        inputButton.setTitle("Send command", for: .normal)
        inputButton.setTitleColor(UIColor.white, for: .normal)
        inputButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        inputButton.addTarget(self, action: #selector(sendCommand), for: .touchUpInside)

        invisibleTextField
            .addAsSubview(to: view)
        
    }
}

// MARK: - UITextFieldDelegate

extension WebContainerViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let script = JSBridge.sendKeyPressed(string)
        webView.evaluateJavaScript(script)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let webViewContentOffset = webView.scrollView.contentOffset.y
        let offset = CGPoint(x: 0, y: webViewContentOffset - 100)
        webView.scrollView.setContentOffset(offset, animated: true)
    }
}
