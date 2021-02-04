//
//  ConfigurationViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/14.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD
import LTMorphingLabel

class ConfigurationViewController: UIViewController {
    
    let userDataModel = UserDataModel()
    var userName = String()
    var userID = String()
    var ageData = String()
    var sexData = String()
    let manImage:UIImage = UIImage(named: "man1")!
    let womanImage:UIImage = UIImage(named: "woman1")!
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var userInforLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData()
        Start()
        
        Design()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func update(_ sender: Any) {
        
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        profileVC.modalTransitionStyle = .coverVertical
        profileVC.modalPresentationStyle = .fullScreen
        self.present(profileVC, animated: true, completion: nil)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        HUD.show(.progress)
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "ageData")
            UserDefaults.standard.removeObject(forKey: "sexData")
            UserDefaults.standard.removeObject(forKey: "userID")
            let LoginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
            LoginVC.modalPresentationStyle = .fullScreen
            
            self.present(LoginVC, animated: true, completion: nil)
            HUD.hide()
            
        } catch let error as NSError {
            print("エラー",error)
        }
        
        
    }
    
    func userData (){
        userDataModel.usercheck()
        
        userName = userDataModel.userName
        userID = userDataModel.userID
        ageData = userDataModel.ageData
        sexData = userDataModel.sexData
    }
    func Start () {
        if sexData == "女性" {
            profileImageView.image = womanImage
        } else if sexData == "男性"{
            profileImageView.image = manImage
        }
        
        userNameLabel.text = userName
        userInforLabel.text = ageData + sexData
    }
    
    func Design () {
        profileImageView.layer.cornerRadius = 65
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 1
        
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
