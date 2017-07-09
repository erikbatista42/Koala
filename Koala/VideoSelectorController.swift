//
//  PhotoSelectorController.swift
//  Koala
//
//  Created by Erik Batista on 7/8/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class VideoSelectorController: UIViewController {
    
    
    var shootADanceButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shoot a dance", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 210, green: 77, blue: 87, alpha: 1)
        button.addTarget(self, action: #selector(shootADance), for: .touchUpInside)
        return button
    }()
    
    func shootADance() {
        let searchTrackTableView = SearchTrackTableView()
        present(searchTrackTableView, animated: true, completion: nil)
    }
    
    var uploadFromLibraryButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload from library", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.backgroundColor = UIColor.rgb(red: 102, green: 51, blue: 153, alpha: 1)
        button.addTarget(self, action: #selector(handleUploadFromLibraryButton), for: .touchUpInside)
        return button
    }()
    
    func handleUploadFromLibraryButton() {
        let imagePickerController = UIImagePickerController()
//        var videoURL: NSURL?
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        var prefersStatusBarHidden: Bool {
            return true
        }
        
        setupNavigationButtons()
        view.addSubview(shootADanceButton)
        shootADanceButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 65, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        
        view.addSubview(uploadFromLibraryButton)
        uploadFromLibraryButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 365, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        
    }
    
    fileprivate func  setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 41, green: 54, blue: 76, alpha: 1)
        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleCancel))
        
        
    }
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}