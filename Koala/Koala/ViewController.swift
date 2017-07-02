//
//  ViewController.swift
//  Koala
//
//  Created by Erik Batista on 6/30/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FacebookLogin

class ViewController: UIViewController, UIScrollViewDelegate, FBSDKLoginButtonDelegate {
    
   
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
//    @IBOutlet weak var mainScrollView: UIScrollView!
//    @IBOutlet weak var pageController: UIPageControl!
//  
//    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    


    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)

//       facebookLoginButton.delegate = self
        
        mainScrollView.frame = view.frame
        mainScrollView.delegate = self
        
        imageArray = [#imageLiteral(resourceName: "sampleImageOne"), #imageLiteral(resourceName: "samp3"), #imageLiteral(resourceName: "sampleImageThree")]
        
        for i in 0..<imageArray.count {
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: 375, height: 425)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.isPagingEnabled = true
            
            mainScrollView.addSubview(imageView)
        }
        
//        self.facebookLoginButton.delegate = self
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
           
            print("User logged in with Facebook..")
        })
    }
    
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        try! FIRAuth.auth()?.signOut()
        
        
        print("User logged out of facebook...")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageController.currentPage = Int(page)
    }
    
    
    
    
    
    
    var pageHeadings = ["Dance","Record","Share"]
    var pageImages = ["","",""]
    
    
  
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

