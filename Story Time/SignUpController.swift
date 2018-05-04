//
//  ViewController.swift
//  Koala
//
//  Created by Erik Batista on 7/5/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo") .withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        let attributedTitle = NSMutableAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.4)])
        tf.attributedPlaceholder = attributedTitle
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 252, green: 41, blue: 125, alpha: 1)
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
            signUpButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        let attributedTitle = NSMutableAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.4)])
        tf.attributedPlaceholder = attributedTitle
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        let attributedTitle = NSMutableAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.4)])
        tf.attributedPlaceholder = attributedTitle
        tf.isSecureTextEntry = true
         tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        button.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    @objc func handleSignup() {
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if let err = error {
                print("Failed to create user:", err)
                let alertController = UIAlertController(title: "ERROR", message: "\(err.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            } else {
                print("Successfully created user:", user?.uid ?? "" )
                
                guard let image = self.plusPhotoButton.imageView?.image else { return }
                
                guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
                
                let fileName = NSUUID().uuidString
                FIRStorage.storage().reference().child("profile_images").child(fileName).put(uploadData, metadata: nil, completion: { (metadata, err) in
                    
                    if let err = err {
                        print("Failed to upload profile image:", err)
                    }
                  guard  let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                    print("Successfully uploaded profile image:",profileImageUrl)
                    
                                    guard let uid = user?.uid else { return }
                    
                                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                                    let values = [uid: dictionaryValues]
                    
                                    FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                                        if let err = err {
                                            print("Failed to save user info into database:", err)
                                            return
                                        }
                                        print("Successfully saved user info to database")
                                        
                                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                                        
                                        mainTabBarController.setupViewControllers()
                                        self.dismiss(animated: true, completion: nil)
                                    })
                    
                })
                

         }
        })
    }
    
    let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.5)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white]))
        
        
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAnAccount() {
      _ =  navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
       
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInputFields()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y = -175
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 175
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
    
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
}



