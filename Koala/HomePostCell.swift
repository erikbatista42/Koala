//
//  HomePostCell.swift
//  Koala
//
//  Created by Erik on 8/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

protocol HomePostCellDelegate {
    func didLike(for cell: HomePostCell)
    func didPressShareButton(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let thumbnailUrl = post?.thumbnailUrl else { return }
            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "heart_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "heart_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoImageView.loadImage(UrlString: thumbnailUrl)
            
            //            usernameLabel.text = "\(post?.user.username ?? "")\n\(timeLabel.attributedText?.string ?? "")"
            usernameLabel.text  = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            
            userProfileImageView.loadImage(UrlString: profileImageUrl)
            
            setupTimeLabel()
        }
    }
    
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.rgb(red: 202, green: 0, blue: 26, alpha: 1)
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "optionsButton").withRenderingMode(.alwaysOriginal), for: .normal)
        //        button.addTarget(self, action: #selector(handleOptionsButton), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "heart_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleLike() {
        delegate?.didLike(for: self)
    }
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 13)
        label.textColor = UIColor.black
        label.isHidden = true
        let userInfo = ["likesLabelInfo": label]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil, userInfo: userInfo)
        return label
    }()
    
    //    @objc func handleLikesLabel(viewController: HomeController, cell: HomePostCell) {
    //        print("Receivedddd Notification")
    ////        likesLabel.text = "6"
    ////        guard let indexPath = viewController.collectionView?.indexPath(for: self) else { return }
    //        guard let indexPath = viewController.collectionView?.indexPath(for: cell) else { return }
    //        let post = viewController.posts[indexPath.item]
    //
    //        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    //
    //        let numOfFollowersRef = FIRDatabase.database().reference().child("followers").child(uid)
    //
    //        numOfFollowersRef.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
    //            print("Got number of followers from selected user")
    //            print(snapshot.childrenCount)
    //            let numOfChildrens = snapshot.childrenCount
    //            self.likesLabel.text = "6"
    //        }, withCancel: { (error) in
    //            print("failed to fetch num of posts: ",error)
    //        })
    //
    //    }
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShareButton() {
        if let delegate = self.delegate {
            delegate.didPressShareButton(for: self)
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white])
        label.attributedText = attributedText
        return label
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitle("username", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 208, green: 2, blue: 27, alpha: 1), for: .normal)
        //        print(123)
        return button
    }()
    
    let blurView: UIView = {
        let view = UIView()
//        view.layer.masksToBounds = false
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 1
       
//        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
//        view.backgroundColor = .black
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blurbg.png")!)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear 
        addSubview(usernameButton)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        addSubview(timeLabel)
        addSubview(blurView)
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        blurView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        userProfileImageView.anchor(top: photoImageView.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 30/2, height: 30/2)
        userProfileImageView.layer.cornerRadius = 30/2
        
//        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        
        setupBottomCellButtonsAndLabels()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleLikesLabel), name: NSNotification.Name(rawValue: "updateLikesLabel"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: Selector(""), name: NSNotification.Name(rawValue: "homePostCellRawValue"), object: nil)
        let userInfo = ["homePostCellInfo": self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homePostCellRawValue"), object: nil, userInfo: userInfo)
    }
    static let homePostCellNotificationName = NSNotification.Name(rawValue: "homePostCellRaw")
    
    func setupTimeLabel() {
        guard let post = self.post else { return }
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        let attributedText = NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.white])
        timeLabel.attributedText = attributedText
    }
    
//    let stackViewBorders: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 10.0
//        view.layer.borderWidth = 1.0
//        view.layer.borderColor = UIColor.black.cgColor
//        return view
//    }()
    
    fileprivate func setupBottomCellButtonsAndLabels() {
        let timeAndOptionsStackView = UIStackView(arrangedSubviews: [userProfileImageView]) //[timeLabel,optionsButton])
        timeAndOptionsStackView.distribution = .fillEqually
        timeAndOptionsStackView.spacing = 10
        addSubview(timeAndOptionsStackView)
        timeAndOptionsStackView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 0, paddingBottom: -8, paddingRight: 8, width: 30, height: 30)

        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
//        addSubview(shareButton)
//        shareButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom:  nil, right: rightAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 92, width: 40, height: 50)
//
//        addSubview(stackViewBorders)
//        stackViewBorders.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 80, height: 30)
//
//        let likeButtonAndLikesLabelStackView = UIStackView(arrangedSubviews: [likesLabel,likeButton])
//        likeButtonAndLikesLabelStackView.distribution = .fillEqually
//        likeButtonAndLikesLabelStackView.backgroundColor = UIColor.magenta
//        addSubview(likeButtonAndLikesLabelStackView)
//
//        likeButtonAndLikesLabelStackView.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 50, height: 40)
    }
    
//    func setupTimeLabelAndProfileImage() {
//        let stackView = UIStackView(arrangedSubviews: [timeLabel,userProfileImageView])
//        stackView.distribution = .fillEqually
//        addSubview(stackView)
//        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
