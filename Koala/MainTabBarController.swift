//
//  MainTabBarController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if FIRAuth.auth()?.currentUser == nil {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }
            return
        }
      
        setupViewControllers()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
       
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        //        tabBar.tintColor = UIColor.rgb(red: 160, green: 160, blue: 160, alpha: 1)
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        viewControllers = [navController, UIViewController()]
    }
}
