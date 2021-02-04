//
//  LoadDBModel.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/10.
//

import Foundation
import Firebase

protocol LoadOKDelegate {
    
    func loadOK(check:Int)
    
}

class LoadDBModel {
    var dataSets = [DataSet]()
    var CMdataSets = [DataSet]()
    var PartdataSets = [DataSet]()
    let db = Firestore.firestore()
    
    
    var loadOKDelegate:LoadOKDelegate?
    
    func loadContents(roomData:String, completion:
                        @escaping ([String]) -> Void)  {
        db.collection(roomData).order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.dataSets = []
            var docList = [String]()
            
            if error != nil  {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let  data = doc.data()
                    
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let ageData = data["ageData"] as? String,let sexData = data["sexData"] as? String,let postDate = data["postDate"] as? Double,let likeCount = data["like"] as? Int,let likeFlagDic = data["likeFlagDic"] as? Dictionary<String,Bool> {
                           
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, ageData:ageData, sexData: sexData, postDate: postDate,likeCount: likeCount, likeFlagDic: likeFlagDic, docID: doc.documentID)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)
                        
                    }
                    docList.append(doc.documentID)
                }
                completion(docList)
                print(completion)
            }
        }
    }
    
    func loadPartContents(roomData:String,FieldData:String,userID:String, completion:
                        @escaping ([String]) -> Void)  {
        db.collection(roomData).whereField("\(FieldData)", isEqualTo: "\(userID)").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.PartdataSets = []
            var docList = [String]()
            print("特定",FieldData,userID)
            
            if error != nil  {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let  data = doc.data()
                    
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let ageData = data["ageData"] as? String,let sexData = data["sexData"] as? String,let postDate = data["postDate"] as? Double,let likeCount = data["like"] as? Int,let likeFlagDic = data["likeFlagDic"] as? Dictionary<String,Bool> {
                           
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, ageData:ageData, sexData: sexData, postDate: postDate,likeCount: likeCount, likeFlagDic: likeFlagDic, docID: doc.documentID)
                        
                        self.PartdataSets.append(newDataSet)
                        self.PartdataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)
                        
                    }
                    docList.append(doc.documentID)
                }
                completion(docList)
                print(completion)
            }
        }
    }
    
   
    func loadComment(CMroomData:String,docID:String){
        db.collection(CMroomData).document(docID).collection("comments").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.CMdataSets = []
            
            if error != nil  {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let  data = doc.data()
                    
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let ageData = data["ageData"] as? String,let sexData = data["sexData"] as? String,let postDate = data["postDate"] as? Double,let likeCount = data["like"] as? Int,let likeFlagDic = data["likeFlagDic"] as? Dictionary<String,Bool> {
                           
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, ageData:ageData, sexData: sexData, postDate: postDate,likeCount: likeCount, likeFlagDic: likeFlagDic, docID: doc.documentID)
                
                        self.CMdataSets.append(newDataSet)
                        self.CMdataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)
                        
                    }
                }
            }
        }
    }
    
    func loadBestComment(CMroomData:String,docID:String,completion: @escaping (DataSet?) -> Void ){
        db.collection(CMroomData).document(docID).collection("comments").order(by: "postDate").order(by: "like",descending: true).addSnapshotListener { [self] (snapShot, error) in
            self.CMdataSets = []
            
            if error != nil  {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let  data = doc.data()
                    
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let ageData = data["ageData"] as? String,let sexData = data["sexData"] as? String,let postDate = data["postDate"] as? Double,let likeCount = data["like"] as? Int,let likeFlagDic = data["likeFlagDic"] as? Dictionary<String,Bool> {
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, ageData:ageData, sexData: sexData, postDate: postDate,likeCount: likeCount, likeFlagDic: likeFlagDic, docID: docID)
                        print("これ",docID)
                        print(snapShot?.documents)
                        self.CMdataSets.append(newDataSet)
                        self.CMdataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)
                    }
                }
            }
            completion(self.CMdataSets.first)
            print("ベストコメントだよ")
        }
    }
    
}
    /*func loadHashTag(hashTag:String){
            //addSnapShotListnerは値が更新される度に自動で呼ばれる
            db.collection("#\(hashTag)").order(by:"postDate").addSnapshotListener { (snapShot, error) in
                
                self.dataSets = []
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                if let snapShotDoc = snapShot?.documents{
       
                    for doc in snapShotDoc{
                        let data = doc.data()
                        if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let ageData = data["ageData"] as? String,let sexData = data["sexData"] as? String,let postDate = data["postDate"] as? Double {

                            let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, ageData:ageData, sexData: sexData, postDate: postDate)

                            self.dataSets.append(newDataSet)
                            self.dataSets.reverse()
                            self.loadOKDelegate?.loadOK(check: 1)

                        }
                        
                        
                    }
                    
                }
                
            }
            
            
        }*/
    


