//
//  LoginController.swift
//  Koala
//
//  Created by Erik Batista on 7/8/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let isFirstLaunch = UserDefaults.isFirstLaunch()
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "KoalaHeaderLabel"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        
        return view
    }()
    
    let dontHaveAnAccountButton: UIButton = {
        let yes = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.5)])
        yes.setAttributedTitle(attributedTitle, for: .normal)
        
        
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white]))

        
        yes.setTitle("Don't have an account? Sign Up", for: .normal)
        yes.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return yes
    }()
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.tintColor = .white
        let attributedTitle = NSMutableAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.4)])
        tf.attributedPlaceholder = attributedTitle
        tf.font = UIFont.systemFont(ofSize: 15.0)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.tintColor = .white
        let attributedTitle = NSMutableAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.4)])
        tf.attributedPlaceholder = attributedTitle
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 252, green: 41, blue: 125, alpha: 1)
            loginButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
            loginButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
        }
    }
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            print("Successfully logged back in with user:", user?.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        view.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        setupUserAgreement()
    }
    
    func setupUserAgreement() {
        if isFirstLaunch {
            print("This is the first launch")
            
            let controller = UIAlertController(title: "Terms and Conditions", message: "'End-User License Agreement (EULA) of Story Time\n\nThis End-User License Agreement' (\"EULA\") is a legal agreement between you and Erik Batista\n\nThis EULA agreement governs your acquisition and use of our Story Time software (\"Software\") directly from Erik Batista or indirectly through a Erik Batista authorized reseller or distributor (a \"Reseller\").\n\nPlease read this EULA agreement carefully before completing the installation process and using the Story Time software. It provides a license to use the Story Time software and contains warranty information and liability disclaimers.\n\nIf you register for a free trial of the Story Time software, this EULA agreement will also govern that trial. By clicking \"accept\" or installing and/or using the Story Time software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by Erik Batista herewith regardless of whether other software is referred to or described herein. The terms also apply to any Erik Batista updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.\n\nLicense Grant\n\nErik Batista hereby grants you a personal, non-transferable, non-exclusive licence to use the Story Time software on your devices in accordance with the terms of this EULA agreement.\n\nYou are permitted to load the Story Time software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the Story Time software.\n\nYou are not permitted to:\n\n\n- Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things\n- Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose\n- Allow any third party to use the Software on behalf of or for the benefit of any third party\n- Use the Software in any way which breaches any applicable local, national or international law\n- use the Software for any purpose that Erik Batista considers is a breach of this EULA agreement\n\n\nIntellectual Property and Ownership\n\nErik Batista shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Erik Batista.\n\nErik Batista reserves the right to grant licences to use the Software to third parties.\n\nTermination\n\nThis EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Erik Batista.\n\nThis EULA was created by eulatemplate.com for Story Time\n\nIt will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.\n\nGoverning Law\n\nThis EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of [COUNTRY].", preferredStyle: .alert)
            
            let agreeButton = UIAlertAction(title: "Agree", style: .default, handler: { alert in
                print(#function)
                
            })
            
            controller.addAction(agreeButton)
            
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
            
            
            
        } else {
            print("Not first time launching")
        }
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually                        
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
}
