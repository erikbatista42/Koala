//
//  ViewController.swift
//  Koala
//
//  Created by Erik Batista on 7/5/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

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
    
    func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        } else {
            signUpButton.isEnabled = true
           signUpButton.backgroundColor = UIColor.rgb(red: 193, green: 201, blue: 209, alpha: 1)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15.0)
        tf.isSecureTextEntry = true
         tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 193, green: 201, blue: 209, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    func handleSignup() {
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if let err = error {
                print("Failed to create user:", err)
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
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)]))
        
        
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAnAccount() {
      _ =  navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.backgroundColor = UIColor(red: 240, green: 241, blue: 246, alpha: 1)
       
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInputFields()
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


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

