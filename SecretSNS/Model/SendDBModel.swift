//
//  sendDBModel.swift
//  Swift6SNS
//
//  Created by 米津純生 on 2020/11/29.
//

import Foundation
import FirebaseFirestore

class SendDBModel {
    
    var userID = String()
    var comment = String()
    var ageData = String()
    var sexData = String()
    var userName = String()
    var likeCount = Int()
    var likeFlagDic = Dictionary<String,Any>()
    var db = Firestore.firestore()
    
    
    init() {
        
    }
    init(userID:String,userName:String,comment:String,ageData:String,sexData:String,likeCount:Int,likeFlagDic:Dictionary<String,Any>) {
        
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.ageData = ageData
        self.sexData = sexData
        self.likeCount = likeCount
        self.likeFlagDic = likeFlagDic
       
        
    }
    
    func sendData(roomData:String) {
        
        self.db.collection(roomData).document().setData(["userID":self.userID as Any, "userName":self.userName as Any,"comment":self.comment as Any,"ageData":self.ageData as Any,"sexData":self.sexData as Any,"postDate":Date().timeIntervalSince1970,"like":0,"likeFlagDic":[userID:false]])
        
        
    }
    
    func sendComment(CMRoomData:String,docID:String) {
        
        self.db.collection(CMRoomData).document(docID).collection("comments").document().setData(["userID":self.userID as Any, "userName":self.userName as Any,"comment":self.comment as Any,"ageData":self.ageData as Any,"sexData":self.sexData as Any,"postDate":Date().timeIntervalSince1970,"like":0,"likeFlagDic":[userID:false]])

    }
    
    
    
    
    
    
    
    func sendHashTag(hashTag:String){
        
        
        
        self.db.collection(hashTag).document().setData(["userID":self.userID as Any, "userName":self.userName as Any,"comment":self.comment as Any,"ageData":self.ageData as Any,"sexData":self.sexData as Any,"postDate":Date().timeIntervalSince1970])
        
        
    }
    
}
