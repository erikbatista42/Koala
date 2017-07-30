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

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            
//            let layout = UICollectionViewFlowLayout()
            
            let videoSelectorController = VideoSelectorController()
            let navController = UINavigationController(rootViewController: videoSelectorController)
            present(navController, animated: true, completion: nil)
            return false 
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
//        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))

        let recordNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "record_unselected"), selectedImage: #imageLiteral(resourceName: "record_selected"))

        let notificationsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "notifications_unselected"), selectedImage: #imageLiteral(resourceName: "notifications_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        //        tabBar.tintColor = UIColor.rgb(red: 160, green: 160, blue: 160, alpha: 1)
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.rgb(red: 56, green: 56, blue: 56, alpha: 1)
//        navigationController?.navigationBar.isTranslucent = false
        
        
        viewControllers = [homeNavController, searchNavController, recordNavController ,notificationsNavController,userProfileNavController]
        
        //modify tab bar items insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        //home
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        
        return navController
    }
}
