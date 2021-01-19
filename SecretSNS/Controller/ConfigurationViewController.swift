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

class ConfigurationViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            self.navigationController?.pushViewController(LoginVC, animated: true)
            HUD.hide()
            
        } catch let error as NSError {
            print("エラー",error)
        }
        
        
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
