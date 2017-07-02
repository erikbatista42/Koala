//
//  MainNavigationController.swift
//  Koala
//
//  Created by Erik Batista on 7/2/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.green
        
        let isLoggedIn = true
        
        if isLoggedIn {
            //Assume user is logged in
            let homeController = HomeController()
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellow
    }
}
