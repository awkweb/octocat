//
//  ViewController.swift
//  octocat
//
//  Created by Tom Meagher on 3/14/18.
//  Copyright © 2018 Tom Meagher. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class ViewController: UIViewController {
    
    private let horizontalPadding: CGFloat = 20
    private let imageWidth: CGFloat = 230
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    let usernameTextField = UITextField()
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let publicReposLabel = UILabel()
    let followersLabel = UILabel()
    let followingsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.frame =
            CGRect(x: 20, y: 50, width: screenWidth - (horizontalPadding * 2), height: 40)
        usernameTextField.placeholder = "Enter GitHub username"
        usernameTextField.font = UIFont.systemFont(ofSize: 15)
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocorrectionType = .no
        usernameTextField.keyboardType = .default
        usernameTextField.returnKeyType = .search
        usernameTextField.clearButtonMode = .whileEditing
        usernameTextField.contentVerticalAlignment = .center
        usernameTextField.autocapitalizationType = .none
        usernameTextField.delegate = self
        self.view.addSubview(usernameTextField)
        usernameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func getUserForUsername(_ username: String) {
        Alamofire
            .request("https://api.github.com/users/\(username)")
            .responseJSON { response in
                if((response.result.value) != nil) {
                    let userJson = JSON(response.result.value!)
                    if userJson["login"] != nil {
                        self.updateUserInfo(userJson)
                    } else {
                        let alert = UIAlertController(title: "No User Found :(", message: "No GitHub user exists with username @\(username). Perhaps you should search again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
    }
    
    public func updateUserInfo(_ userJson: JSON) {
        let url = URL(string: userJson["avatar_url"].stringValue)
        profileImageView.kf.setImage(with: url)
        profileImageView.frame =
            CGRect(x: (screenWidth / 2) - (imageWidth / 2), y: 105, width: imageWidth, height: imageWidth)
        profileImageView.layer.cornerRadius = 6
        profileImageView.clipsToBounds = true
        self.view.addSubview(profileImageView)
        
        nameLabel.frame =
            CGRect(x: 20, y: 340, width: screenWidth - (horizontalPadding * 2), height: 45)
        nameLabel.text = userJson["name"].stringValue
        nameLabel.font = UIFont.systemFont(ofSize: 26.0, weight: .bold)
        nameLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
        
        usernameLabel.frame =
            CGRect(x: 20, y: 370, width: screenWidth - (horizontalPadding * 2), height: 40)
        usernameLabel.text = userJson["login"].stringValue
        usernameLabel.font = UIFont.systemFont(ofSize: 20.0)
        usernameLabel.textColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        usernameLabel.textAlignment = .center
        self.view.addSubview(usernameLabel)
        
        publicReposLabel.frame =
            CGRect(x: 20, y: 420, width: screenWidth / 3, height: 40)
        publicReposLabel.text = userJson["public_repos"].stringValue
        publicReposLabel.font = UIFont.systemFont(ofSize: 26.0, weight: .bold)
        publicReposLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        publicReposLabel.textAlignment = .center
        self.view.addSubview(publicReposLabel)
        self.addStatLabel(text: "repos", x: 20)

        followersLabel.frame =
            CGRect(x: screenWidth / 3, y: 420, width: screenWidth / 3, height: 40)
        followersLabel.text = userJson["followers"].stringValue
        followersLabel.font = UIFont.systemFont(ofSize: 26.0, weight: .bold)
        followersLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        followersLabel.textAlignment = .center
        self.view.addSubview(followersLabel)
        self.addStatLabel(text: "followers", x: screenWidth / 3)
        
        followingsLabel.frame =
            CGRect(x: (screenWidth * 2 / 3) - horizontalPadding, y: 420, width: screenWidth / 3, height: 40)
        followingsLabel.text = userJson["following"].stringValue
        followingsLabel.font = UIFont.systemFont(ofSize: 26.0, weight: .bold)
        followingsLabel.textColor = UIColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        followingsLabel.textAlignment = .center
        self.view.addSubview(followingsLabel)
        self.addStatLabel(text: "following", x: (screenWidth * 2 / 3) - horizontalPadding)
    }
    
    private func addStatLabel(text: String, x: CGFloat) {
        let statLabel =
            UILabel(frame: CGRect(x: x, y: 445, width: screenWidth / 3, height: 40))
        statLabel.text = text
        statLabel.font = UIFont.systemFont(ofSize: 16.0)
        statLabel.textAlignment = .center
        self.view.addSubview(statLabel)
    }

}

// MARK:- ---> UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let username = textField.text {
            if !username.isEmpty {
                getUserForUsername(username)
            }
        }
        return true
    }
    
}

// MARK: UITextFieldDelegate <---

