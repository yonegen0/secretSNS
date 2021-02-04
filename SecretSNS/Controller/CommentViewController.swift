//
//  CommentViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/15.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate {
    
    var docID = String()
    var CMdocID = String()
    
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    var roomString = String()
    let manImage:UIImage = UIImage(named: "man2")!
    let womanImage:UIImage = UIImage(named: "woman2")!
    let manImage2:UIImage = UIImage(named: "man3")!
    let womanImage2:UIImage = UIImage(named: "woman3")!
    
    let userDataModel = UserDataModel()
    var userID = String()
    var userName = String()
    var ageData = String()
    var sexData = String()
    
    var PostuserName = String()
    var PostageData = String()
    var PostsexData = String()
    var comment = String()
    var count = Int()
    var flag = Bool()
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userInforLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    let screenSize = UIScreen.main.bounds.size
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentStart()
        userData()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        print(flag)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDBModel.loadComment(CMroomData: roomString, docID: docID)
        
        if flag as! Bool == true{
            
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        
        if textfield.text?.isEmpty == true{
            
            return
            
        }
        
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, comment: textfield.text!, ageData: ageData, sexData: sexData,likeCount: 0,likeFlagDic: [userID:false])
        sendDBModel.sendComment(CMRoomData: roomString, docID: docID)
        textfield.text = ""
        textfield.resignFirstResponder()
        
    }
    
    func loadOK(check: Int) {
        
        if check == 1 {
            tableView.reloadData()
        }
        
    }
    
    @IBAction func `return`(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.CMdataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        tableView.rowHeight = 150
        
        let sexData = loadDBModel.CMdataSets[indexPath.row].sexData
        let ageData = loadDBModel.CMdataSets[indexPath.row].ageData
        let userName = loadDBModel.CMdataSets[indexPath.row].userName
        
        cell.commentLabel.numberOfLines = 0
        
        if sexData == "女性" {
            cell.profileImageView.image = womanImage2
        } else if sexData == "男性"{
            cell.profileImageView.image = manImage2
        }
        cell.userNameLabel.text = userName
        cell.userInforLabel.text = ageData + sexData
        cell.commentLabel.text = "\(loadDBModel.CMdataSets[indexPath.row].comment)"
        cell.countLabel.text = String(self.loadDBModel.CMdataSets[indexPath.row].likeCount)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(Comment(_:)), for: .touchUpInside)
        
        if (self.loadDBModel.CMdataSets[indexPath.row].likeFlagDic[userID] != nil) == true{
            
            
            let flag = self.loadDBModel.CMdataSets[indexPath.row].likeFlagDic[userID]
            
            if flag! as! Bool == true{
                
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        print(docID)
        
        return cell
    }
    
    func commentStart () {
        if PostsexData == "女性" {
            profileImageView.image = womanImage
        } else if PostsexData == "男性"{
            profileImageView.image = manImage
        }
        
        userNameLabel.text = PostuserName
        userInforLabel.text = PostageData + PostsexData
        commentLabel.text = comment
        countLabel.text = String(count)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
              
    let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
              
        textfield.frame.origin.y = screenSize.height - keyboardHeight - textfield.frame.height
              sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
              
              
          }

       @objc func keyboardWillHide(_ notification:NSNotification){

        textfield.frame.origin.y = screenSize.height - textfield.frame.height
              
              sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
       
          
           guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}


              UIView.animate(withDuration: duration) {
                  
                  let transform = CGAffineTransform(translationX: 0, y: 0)
                  self.view.transform = transform
                  
              }
              
          }
    
    @objc func like(_ sender:UIButton){
        
        //値を送信
        var count = Int()
        let flag = self.loadDBModel.CMdataSets[sender.tag].likeFlagDic[userID]
        print(flag)
        print(userID)
        
        if flag == nil{
            
            count = self.loadDBModel.CMdataSets[sender.tag].likeCount + 1
            db.collection("\(roomString)").document(docID).collection("comments").document(loadDBModel.CMdataSets[sender.tag].docID).setData(["likeFlagDic":[userID:true]], merge: true)
            
        }else{
            
            if flag! as! Bool == true{
                
                count = self.loadDBModel.CMdataSets[sender.tag].likeCount - 1
                db.collection("\(roomString)").document(docID).collection("comments").document(loadDBModel.CMdataSets[sender.tag].docID).setData(["likeFlagDic":[userID:false]], merge: true)
                
            }else{
                
                count = self.loadDBModel.CMdataSets[sender.tag].likeCount + 1
                db.collection("\(roomString)").document(docID).collection("comments").document(loadDBModel.CMdataSets[sender.tag].docID).setData(["likeFlagDic":[userID:true]], merge: true)
                
            }
            
        }
        
        //count情報を送信
        db.collection("\(roomString)").document(docID).collection("comments").document(loadDBModel.CMdataSets[sender.tag].docID).updateData(["like":count], completion: nil)
        tableView.reloadData()
    }
    @objc func Comment(_ sender:UIButton){
    }
    func userData (){
        userDataModel.usercheck()
        
        userName = userDataModel.userName
        userID = userDataModel.userID
        ageData = userDataModel.ageData
        sexData = userDataModel.sexData
    }
    func DocData() {
        
        db.collection("\(roomString)").document(docID).collection("comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.CMdocID.append(document.documentID)
                }
            }
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
