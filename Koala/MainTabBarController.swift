//
//  MainTabBarController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
import Hero

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        isHeroEnabled = true
//        if selectedViewController == nil || viewController == selectedViewController {
//            return false
//        }
//        
//        let fromView = selectedViewController!.view
//        let toView = viewController.view
//        
//        
//        
////        UIView.transition(from: fromView!, to: toView!, duration: 1, options: [], completion: nil)
////        UIView.transition(from: fromView!, to: toView!, duration: 1, options: .showHideTransitionViews, completion: nil)
        
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
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
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        homeNavController.tabBarItem.title = "Home"

        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        searchNavController.tabBarItem.title = "Explore"

        let recordNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "addButton").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "addButton").withRenderingMode(.alwaysOriginal))

        let notificationsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "notifications_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "notifications_selected").withRenderingMode(.alwaysOriginal), rootViewController: ActivityTVC())
        notificationsNavController.tabBarItem.title = "Activity"
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        userProfileNavController.tabBarItem.title = "Profile"
        
        //        tabBar.tintColor = UIColor.rgb(red: 160, green: 160, blue: 160, alpha: 1)
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.rgb(red: 47, green: 72, blue: 121, alpha: 1)
        tabBar.isTranslucent = false
        
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
