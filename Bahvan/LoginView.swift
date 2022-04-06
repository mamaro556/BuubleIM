//
//  LoginView.swift
//  Bahvan
//
//  Created by Marvin Amaro on 11/17/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

import UIKit

class LoginView: UIView {

    var loginAction:(() -> Void)?
    var signupAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        let stackView = mainStackView()
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints
        stackView.widthAnchor.constraint(equalToConstant: self.frame.width - 60).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 1
        tf.backgroundColor = UIColor(red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0)
        tf.textColor = UIColor(white: 0.0, alpha: 0.8)
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.autocorrectionType = .no
        //placeholder
        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "email", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(white: 0.3, alpha: 0.7)]))
        tf.attributedPlaceholder = placeholder
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.layer.cornerRadius = 1
        tf.backgroundColor = UIColor(red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0)
        tf.textColor = UIColor(white: 0.0, alpha: 0.8)
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.autocorrectionType = .no
        //placeholder
        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(white: 0.3, alpha: 0.7)]))
        tf.attributedPlaceholder = placeholder
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Login"))
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Sign Up"))
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    func mainStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       passwordTextField,
                                                       loginButton,
                                                       signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
        
        
    }
    
    @objc func handleLogin() {
        loginAction?()
    }
    
    @objc func handleSignup() {
        signupAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
