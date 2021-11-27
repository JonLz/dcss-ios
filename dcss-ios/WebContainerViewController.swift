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
    let invisibleTextField = UITextField()
    var keyCommandView: UIView?

    private var keyCommandViewConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        attachChildViewControllers()
        configureKeyboardObservations()
        
        invisibleTextField.delegate = self
        invisibleTextField.autocorrectionType = .no
        invisibleTextField.autocapitalizationType = .none
        invisibleTextField.inputAssistantItem.leadingBarButtonGroups = []
        invisibleTextField.inputAssistantItem.trailingBarButtonGroups = []

        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
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

        invisibleTextField
            .addAsSubview(to: view)
    }
    
    private func attachChildViewControllers() {
        let kcvc = KeyCommandsViewController(onKeyCommandTapped: { [weak self] keyCommand in
            let script = JSBridge.sendKeydownPressed(keyCommand.rawValue)
            self?.webView.evaluateJavaScript(script)
        }, onKeyboardTapped: { [weak self] in
            guard let self = self else {
                return
            }
            if self.invisibleTextField.isFirstResponder {
                self.invisibleTextField.resignFirstResponder()
            } else {
                self.invisibleTextField.becomeFirstResponder()
            }
        })
        let kcView = kcvc.view!
        keyCommandView = kcView
        
        kcvc.willMove(toParent: self)
        addChild(kcvc)
        kcView
            .addAsSubview(to: view)
        kcView.translatesAutoresizingMaskIntoConstraints = false
        configureKeyCommandViewConstraints(keyboardVisible: false)
        kcvc.didMove(toParent: self)
    }
    
    private func configureKeyCommandViewConstraints(keyboardVisible: Bool, keyboardHeight: CGFloat = 0) {
        guard let kcView = keyCommandView else {
            return
        }
        
        NSLayoutConstraint.deactivate(keyCommandViewConstraints)
        defer { NSLayoutConstraint.activate(keyCommandViewConstraints) }

        if keyboardVisible {
            keyCommandViewConstraints = [
                kcView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                kcView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight),
                kcView.heightAnchor.constraint(equalToConstant: 32)
            ]
        } else {
            keyCommandViewConstraints = [
                kcView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                kcView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                kcView.heightAnchor.constraint(equalToConstant: 32)
            ]
        }
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
        guard
            let curve = notification.keyboardAnimationCurve,
            let duration = notification.keyboardAnimationDuration,
            let keyboardHeight = notification.keyboardHeight else {
                return
            }

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            self.setWebviewContentInsets(keyboardVisible: true, keyboardHeight: keyboardHeight)
            self.configureKeyCommandViewConstraints(keyboardVisible: true, keyboardHeight: keyboardHeight)
            self.view?.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard
            let curve = notification.keyboardAnimationCurve,
            let duration = notification.keyboardAnimationDuration else {
                return
            }

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            self.setWebviewContentInsets(keyboardVisible: false)
            self.configureKeyCommandViewConstraints(keyboardVisible: false)
            self.view?.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    @objc func setWebviewContentInsets(keyboardVisible: Bool, keyboardHeight: CGFloat = 0) {
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

private extension NSNotification {
    var keyboardAnimationCurve: UIView.AnimationCurve? {
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        guard let curveValue = userInfo?[curveKey] as? Int else {
            return nil
        }
        return UIView.AnimationCurve(rawValue: curveValue)
    }
    
    var keyboardAnimationDuration: Double? {
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        return userInfo?[durationKey] as? Double
    }
    
    var keyboardHeight: CGFloat? {
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = userInfo?[frameKey] as? NSValue
        return keyboardFrameValue?.cgRectValue.height
    }
}
