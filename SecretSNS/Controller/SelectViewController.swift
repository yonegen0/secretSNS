//
//  SelectViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/10.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SelectViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate {
    
    
 
    @IBOutlet var tableView: UITableView!
    
    let manImage:UIImage = UIImage(named: "man2")!
    let womanImage:UIImage = UIImage(named: "woman2")!
    
    var roomNumber = Int()
    var roomString = String()
    let roomDataModel = RoomDataModel()
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    var docID = [String]()
    var docString = String()
    
    var userID = String()
    
    var centerOfCard : CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }
    
        print("\(userID)")
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        print(docID)
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
    }
    
    func loadOK(check: Int) {
        
        if check == 1 {
            tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roomCheck()
        
        DocData()
       
        self.navigationController?.isNavigationBarHidden = false

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.dataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        tableView.rowHeight = 350
        
        let sexData = loadDBModel.dataSets[indexPath.row].sexData
        let ageData = loadDBModel.dataSets[indexPath.row].ageData
        let userName = loadDBModel.dataSets[indexPath.row].userName
        
        cell.commentLabel.numberOfLines = 0
        
        if sexData == "女性" {
            cell.profileImageView.image = womanImage
        } else if sexData == "男性"{
            cell.profileImageView.image = manImage
        }
        cell.userNameLabel.text = userName
        cell.userInforLabel.text = ageData + sexData
        cell.commentLabel.text = "\(loadDBModel.dataSets[indexPath.row].comment)"
        cell.countLabel.text = String(self.loadDBModel.dataSets[indexPath.row].likeCount)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(Comment(_:)), for: .touchUpInside)
        
        if (self.loadDBModel.dataSets[indexPath.row].likeFlagDic[userID] != nil) == true{
            
            
            let flag = self.loadDBModel.dataSets[indexPath.row].likeFlagDic[userID]
            
            if flag! as! Bool == true{
                
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let commentVC = self.storyboard?.instantiateViewController(identifier: "commentVC") as! CommentViewController
        
        let sexData = loadDBModel.dataSets[indexPath.row].sexData
        let ageData = loadDBModel.dataSets[indexPath.row].ageData
        let userName = loadDBModel.dataSets[indexPath.row].userName
        
        commentVC.userName = userName
        commentVC.ageData = ageData
        commentVC.sexData = sexData
        commentVC.comment = "\(loadDBModel.dataSets[indexPath.row].comment)"
        commentVC.count = self.loadDBModel.dataSets[indexPath.row].likeCount
        
        commentVC.docID = docID[indexPath.row]
        commentVC.roomString = self.roomString
        commentVC.modalTransitionStyle = .flipHorizontal
        commentVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(commentVC, animated: true, completion: nil)

        
        
    }
    
    func roomCheck () {
        
        roomDataModel.roomNumber = roomNumber
        
        roomDataModel.roomLoadData()
        
        roomString = roomDataModel.roomString
        
        loadDBModel.loadContents(roomData: roomString)
        
        print(roomString)
        
    }
    
    func DocData() {
        
        db.collection("\(roomString)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.docID.append(document.documentID)
                }
            }
        }
        
    }
    
    @objc func like(_ sender:UIButton){
            
        //値を送信
        print(docString)
        var count = Int()
        let flag = self.loadDBModel.dataSets[sender.tag].likeFlagDic[userID]
        print(flag)
        print(userID)
        
        if flag == nil{
            
            count = self.loadDBModel.dataSets[sender.tag].likeCount + 1
            db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].docID).setData(["likeFlagDic":[userID:true]], merge: true)
            
        }else{
            
            if flag! as! Bool == true{
                
                count = self.loadDBModel.dataSets[sender.tag].likeCount - 1
                db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].docID).setData(["likeFlagDic":[userID:false]], merge: true)

            }else{
                
                count = self.loadDBModel.dataSets[sender.tag].likeCount + 1
                db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].docID).setData(["likeFlagDic":[userID:true]], merge: true)

            }
            
        }
    
        //count情報を送信
        db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].docID).updateData(["like":count], completion: nil)
        tableView.reloadData()
        
    }
    
    @objc func Comment(_ sender:UIButton){
        let commentVC = self.storyboard?.instantiateViewController(identifier: "commentVC") as! CommentViewController
        
        let sexData = loadDBModel.dataSets[sender.tag].sexData
        let ageData = loadDBModel.dataSets[sender.tag].ageData
        let userName = loadDBModel.dataSets[sender.tag].userName
        
        commentVC.userName = userName
        commentVC.ageData = ageData
        commentVC.sexData = sexData
        commentVC.comment = "\(loadDBModel.dataSets[sender.tag].comment)"
        commentVC.count = self.loadDBModel.dataSets[sender.tag].likeCount
        
        commentVC.docID = docID[sender.tag]
        commentVC.roomString = self.roomString
        commentVC.modalTransitionStyle = .flipHorizontal
        commentVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(commentVC, animated: true, completion: nil)

        
    }
    
}
