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
    let CMmanImage:UIImage = UIImage(named: "man3")!
    let CMwomanImage:UIImage = UIImage(named: "woman3")!
    let personImage:UIImage = UIImage(named: "person")!
    
    var roomNumber = Int()
    var roomString = String()
    let roomDataModel = RoomDataModel()
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    var CMdataSets = [DataSet]()
    
    var userID = String()
    
    var centerOfCard : CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        roomCheck()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        print("viewdid")
    }
    
    func loadOK(check: Int) {
        
        if check == 1 {
            tableView.reloadData()
            print("loadok")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        loadDBModel.loadContents(roomData: roomString, completion: { docID in
            
            docID.forEach { id in
                print(id)
                dispatchGroup.enter()
                dispatchQueue.async {
                    self.loadDBModel.loadBestComment(CMroomData: self.roomString, docID: id ,completion:  {dataSet in
                        if let dataSet = dataSet {
                            self.CMdataSets.append(dataSet)
                        }
                        dispatchGroup.leave()
                    })
                }
            }
        })
    
        dispatchGroup.notify(queue: .main) {
            print("リロードされるよ")
            self.tableView.reloadData()
        }

        print("viewwill")
    }
    
    
    @IBAction func `return`(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.dataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        tableView.rowHeight = 400
        
        let sexData = loadDBModel.dataSets[indexPath.row].sexData
        let ageData = loadDBModel.dataSets[indexPath.row].ageData
        let userName = loadDBModel.dataSets[indexPath.row].userName
        let docid = loadDBModel.dataSets[indexPath.row].docID
        print("ここだよ",docid)
        print("CMData",CMdataSets)
        
        if let CMData = CMdataSets.first(where: {$0.docID == docid}) {
            
    
            if CMData.sexData == "女性" {
                cell.CMImageView.image = CMwomanImage
            } else if CMData.sexData == "男性"{
                cell.CMImageView.image = CMmanImage
            }
            cell.Number1.isHidden = false
            cell.BestComment.font = UIFont(name: "YuseiMagic-Regular", size: 17)
            cell.CMuserNameLabel.text = CMData.userName
            cell.CMuserNameLabel.font = UIFont(name: "YuseiMagic-Regular", size: 17)
            cell.CMuserInforLabel.text = CMData.ageData + CMData.sexData
            cell.CMcommentLabel.text = "\(CMData.comment)"
        } else {
            
            cell.CMImageView.image = personImage
            cell.Number1.isHidden = true
            cell.CMuserNameLabel.text = "まだコメントがありません"
            cell.CMuserNameLabel.font = .systemFont(ofSize: 25)
            cell.CMuserInforLabel.text = ""
            cell.CMcommentLabel.text = ""
        }
        
        cell.commentLabel.numberOfLines = 0
        
        if sexData == "女性" {
            cell.profileImageView.image = womanImage
        } else if sexData == "男性"{
            cell.profileImageView.image = manImage
        }
        
        cell.userNameLabel.text = userName
        cell.userNameLabel.font = UIFont(name: "YuseiMagic-Regular", size: 17)
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
        print("cellforat")
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let commentVC = self.storyboard?.instantiateViewController(identifier: "commentVC") as! CommentViewController
        
        let sexData = loadDBModel.dataSets[indexPath.row].sexData
        let ageData = loadDBModel.dataSets[indexPath.row].ageData
        let userName = loadDBModel.dataSets[indexPath.row].userName
        
        commentVC.PostuserName = userName
        commentVC.PostageData = ageData
        commentVC.PostsexData = sexData
        commentVC.comment = "\(loadDBModel.dataSets[indexPath.row].comment)"
        commentVC.count = self.loadDBModel.dataSets[indexPath.row].likeCount
        commentVC.flag = self.loadDBModel.dataSets[indexPath.row].likeFlagDic[userID] as? Bool ?? false
        print(userID)
        commentVC.docID = loadDBModel.dataSets[indexPath.row].docID
        commentVC.roomString = self.roomString
        commentVC.modalTransitionStyle = .crossDissolve
        commentVC.modalPresentationStyle = .fullScreen
        self.present(commentVC, animated: true, completion: nil)

        
        
    }
    
    func roomCheck () {
        
        roomDataModel.roomNumber = roomNumber
        
        roomDataModel.roomLoadData()
        
        roomString = roomDataModel.roomString
        
    
        print(roomString)
        
    }
    
    @objc func like(_ sender:UIButton){
            
        //値を送信
        var count = Int()
        let flag = self.loadDBModel.dataSets[sender.tag].likeFlagDic[userID] 
        print(userID)
        
        if flag == nil{
            
            count = self.loadDBModel.dataSets[sender.tag].likeCount + 1
            db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].docID).setData(["likeFlagDic":[userID:true]], merge: true)
            
        }else{
            
            if flag as! Bool == true{
                
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
        
        commentVC.PostuserName = userName
        commentVC.PostageData = ageData
        commentVC.PostsexData = sexData
        commentVC.comment = "\(loadDBModel.dataSets[sender.tag].comment)"
        commentVC.count = self.loadDBModel.dataSets[sender.tag].likeCount
        commentVC.flag = self.loadDBModel.dataSets[sender.tag].likeFlagDic[userID] as? Bool ?? false
        
        commentVC.docID = loadDBModel.dataSets[sender.tag].docID
        commentVC.roomString = self.roomString
        commentVC.modalTransitionStyle = .crossDissolve
        commentVC.modalPresentationStyle = .fullScreen
        self.present(commentVC, animated: true, completion: nil)

        
    }
    
}
