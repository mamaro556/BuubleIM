//
//  LoginController.swift
//  Bahvan
//
//  Created by Marvin Amaro on 11/17/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

import UIKit

@objc class LoginController: UIViewController {

    var window: UIWindow?
    var loginView:LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/250, green: 250/250, blue: 210/255, alpha: 1.0)
        setupView()
    }

    func setupView() {
        let mainView = LoginView(frame: self.view.frame)
        self.loginView = mainView
        self.loginView.loginAction = loginPressed
        self.loginView.signupAction = signupPressed
        self.view.addSubview(self.loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false

        //constraints
        loginView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        loginView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        loginView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func loginPressed() {
        let app: AppDelegate = appDelegate()
        app.jidstring = loginView.emailTextField.text
        app.passwordstring = loginView.passwordTextField.text
        app.loadHomeControllers()
        print("login button pressed")
    }
    
    func LoadHomeControllers() {
        

    }
    
    func signupPressed() {
        print("signup button pressed")
    }

    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
