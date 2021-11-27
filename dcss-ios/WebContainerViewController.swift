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
        attachChildViewControllers()
        configureKeyboardObservations()
        
        invisibleTextField.delegate = self
        invisibleTextField.autocorrectionType = .no
        invisibleTextField.autocapitalizationType = .none

        let url = URL(string: "https://crawl.kelbi.org/#lobby")!
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func sendCommand() {
        invisibleTextField.becomeFirstResponder()
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
    
    private func attachChildViewControllers() {
        let kcvc = KeyCommandsViewController() { [weak self] keyCommand in
            let script = JSBridge.sendKeydownPressed(keyCommand.rawValue)
            self?.webView.evaluateJavaScript(script)
        }
        let kcView = kcvc.view!
        kcvc.willMove(toParent: self)
        addChild(kcvc)
        
        kcView
            .addAsSubview(to: view)
        kcView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kcView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.25),
            kcView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
            kcView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            kcView.bottomAnchor.constraint(equalTo: inputButton.topAnchor)
        ])
        
        kcvc.didMove(toParent: self)
    }
    
    private func configureKeyboardObservations() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            setWebviewContentInsets(keyboardVisible: true, keyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            setWebviewContentInsets(keyboardVisible: false, keyboardHeight: keyboardHeight)
        }
    }
    
    @objc func setWebviewContentInsets(keyboardVisible: Bool, keyboardHeight: CGFloat) {
        let insets = keyboardVisible ? UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0) : UIEdgeInsets.zero
        webView.scrollView.contentInset = insets
        webView.scrollView.scrollIndicatorInsets = insets
    }
}

// MARK: - UITextFieldDelegate

extension WebContainerViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let script = JSBridge.sendKeyPressed(string)
        webView.evaluateJavaScript(script)
        return false
    }
}
