//
//  MainTabBarController.swift
//  Koala
//
//  Created by Erik Batista on 7/6/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase
//import Hero

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
        if index == 1 {
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
            if Auth.auth().currentUser == nil {
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
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_selected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
//        homeNavController.tabBarItem.title = "Home"

        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "explore"), selectedImage: #imageLiteral(resourceName: "explore"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
//        searchNavController.tabBarItem.title = "Explore"

        let recordNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "addicon8").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "addicon8").withRenderingMode(.alwaysOriginal))

        
        tabBar.tintColor = .white
//        tabBar.tintColor = UIColor.rgb(red: 118, green: 133, blue: 182, alpha: 1)
        tabBar.barTintColor = UIColor.rgb(red: 28, green: 34, blue: 55, alpha: 1)
        tabBar.isTranslucent = false
        
        viewControllers = [homeNavController, recordNavController, searchNavController]
        
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
