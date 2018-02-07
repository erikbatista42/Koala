//
//  UserProfileHeader.swift
//  Koala
//
//  Created by Erik Batista on 7/7/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import Firebase

protocol editProfileAlertView: class {
    func showAlert()
}

class UserProfileHeader: UICollectionViewCell {
    
    
    weak var delegate: editProfileAlertView?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(UrlString: profileImageUrl)
            
            usernameLabel.text = "@\(user?.username ?? "")"
            
            
            guard let numOfPosts = user?.numOfPosts else { return }
            vloggiesLabel.text = "\(numOfPosts)"
            print("this is the number of posts: \(numOfPosts)")
            
            setupEditFollowButton()
            //            followingLabel.text = user?.videos
            setupHeaderLabels()
        }
    }
    
    func setupHeaderLabels() {
        guard let uid = self.user?.uid else { return }
        // following label
        let followingRef = FIRDatabase.database().reference().child("following").child(uid)
        
        followingRef.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            print("Got number of users following from selected user")
            print(snapshot.childrenCount)
            let numOfChildrens = snapshot.childrenCount
            
            let attributedText = NSMutableAttributedString(string: "\(numOfChildrens)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedText.append(NSAttributedString(string: "\n following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
            self.followingLabel.attributedText = attributedText
            self.followingLabel.textAlignment = .center
            self.followingLabel.numberOfLines = 0
        }, withCancel: { (error) in
            print("failed to fetch num of posts: ",error)
        })
        
        // Number of followers label
        let numOfFollowersRef = FIRDatabase.database().reference().child("followers").child(uid)
        
        numOfFollowersRef.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            print("Got number of followers from selected user")
            print(snapshot.childrenCount)
            let numOfChildrens = snapshot.childrenCount
            
            let attributedText = NSMutableAttributedString(string: "\(numOfChildrens)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedText.append(NSAttributedString(string: "\n fans", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
            self.followersLabel.attributedText = attributedText
            self.followersLabel.textAlignment = .center
            self.followersLabel.numberOfLines = 0
        }, withCancel: { (error) in
            print("failed to fetch num of posts: ",error)
        })
        
        // Number of videos label
        let numOfPostsRef = FIRDatabase.database().reference().child("posts").child(uid)
        
        numOfPostsRef.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            print("Got number of posts from selected user")
            print(snapshot.childrenCount)
            let numOfChildrens = snapshot.childrenCount
            
            let attributedText = NSMutableAttributedString(string: "\(numOfChildrens)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedText.append(NSAttributedString(string: "\n videos", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
            self.vloggiesLabel.attributedText = attributedText
            self.vloggiesLabel.textAlignment = .center
            self.vloggiesLabel.numberOfLines = 0
        }, withCancel: { (error) in
            print("failed to fetch num of posts: ",error)
        })
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInCurrentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInCurrentUserId == userId {
            //edit Profile
        } else {
            
            //check if following
            FIRDatabase.database().reference().child("following").child(currentLoggedInCurrentUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("failed to check if following:", err)
            })
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic ...")
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            
            //following
            let ref = FIRDatabase.database().reference().child("following").child(currentUserId).child(userId)
            ref.removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                print("Successfully unfollowed user:", self.user?.username ?? "")
                self.setupFollowStyle()
            })
            
            self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 252, green: 41, blue: 125, alpha: 1)
            
            //followers
            let followersRef = FIRDatabase.database().reference().child("followers").child(userId).child(currentUserId)
            followersRef.removeValue(completionBlock: { (err, followersRef) in
                if let err = err {
                    print("failed to put user on followers: ", err)
                    return
                }
                print("Successfully inserted user on followers")
            })
            
        } else if editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
            delegate?.showAlert()
        } else {
            //            //following
            let ref = FIRDatabase.database().reference().child("following").child(currentUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print("failed to follow user")
                    return
                }
                print("successfully followed user:", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 252, green: 41, blue: 125, alpha: 1)
                self.editProfileFollowButton.setTitleColor(.white, for: .normal)
            }
            
            //Followers
            let followersRef = FIRDatabase.database().reference().child("followers").child(userId)
            let followerValues = [currentUserId: 1]
            followersRef.updateChildValues(followerValues, withCompletionBlock: { (err, followersRef) in
                if err != nil {
                    //print err
                    return
                }
                //print success
            })
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 77, green: 90, blue: 255, alpha: 1)
        self.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor.white.cgColor
        self.editProfileFollowButton.layer.borderWidth = 1
        
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.rgb(red: 44, green: 53, blue: 151, alpha: 1).cgColor
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "@username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1)
        return label
    }()
    
    let vloggiesLabel: UILabel = {
        //Fetch num of posts
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n vloggies", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n fans", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 120, green: 226, blue: 250, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 171, green: 185, blue: 199, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.rgb(red: 28, green: 34, blue: 55, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        backgroundColor = UIColor.rgb(red: 27, green: 52, blue: 100, alpha: 1)
        //        backgroundColor = UIColor.rgb(red: 206, green: 12, blue: 36, alpha: 1) // red
        backgroundColor = UIColor.rgb(red: 33, green: 41, blue: 67, alpha: 1)
        //        backgroundColor = UIColor.rgb(red: 205, green: 212, blue: 221, alpha: 1) // Type of gray
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: followersLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 220, height: 30)
        editProfileFollowButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [vloggiesLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        addSubview(stackView)
        stackView.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 50)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

