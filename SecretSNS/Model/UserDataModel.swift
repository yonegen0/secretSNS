//
//  userDataModel.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/13.
//

import Foundation
import Firebase
import FirebaseAuth

class UserDataModel {
    
    var userName = String()
    var ageData = String()
    var sexData = String()
    var userID = String()
    
    
    func usercheck() {
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "ageData") != nil {
            ageData = UserDefaults.standard.object(forKey: "ageData") as! String
        }
        if UserDefaults.standard.object(forKey: "sexData") != nil {
            sexData = UserDefaults.standard.object(forKey: "sexData") as! String
        }
        if UserDefaults.standard.object(forKey: "userID") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }
        
    }
}
