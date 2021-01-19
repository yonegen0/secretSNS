//
//  SeachViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/17.
//

import UIKit
import Firebase
import FirebaseFirestore

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    var searchData = [Any]()
    
    @IBOutlet var categoryTextField: UITextField!
    var categoryPickerView = UIPickerView()
    var categoryToolbar = UIToolbar()
    var categoryData : [String] = [""]
    
    @IBOutlet var tableView: UITableView!
    
    let manImage:UIImage = UIImage(named: "man2")!
    let womanImage:UIImage = UIImage(named: "woman2")!
    
    let roomDataModel = RoomDataModel()
    let loadDBModel = LoadDBModel()
    let db = Firestore.firestore()
    var roomString = String()
    var docID = [String]()
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        categoryData +=  roomDataModel.roomData
        
        createPickerView()
        
        self.categoryTextField.inputView = categoryPickerView
        self.categoryTextField.inputAccessoryView = categoryToolbar
        
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")

        // Do any additional setup after loading the view.
    }
    
    func loadOK(check: Int) {
        
        if check == 1 {
            tableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            //キーボードを閉じる。
            searchBar.endEditing(true)
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
        print(docID)
        cell.likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        
        if (self.loadDBModel.dataSets[indexPath.row].likeFlagDic[userID] != nil) == true{
            
            
            let flag = self.loadDBModel.dataSets[indexPath.row].likeFlagDic[userID]
            
            if flag! as! Bool == true{
                
                cell.likeButton.setImage(UIImage(named: "heart"), for: .normal)
            }else{
                cell.likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        let commentVC = self.storyboard?.instantiateViewController(identifier: "commentVC") as! CommentViewController
        commentVC.docID = docID[indexPath.row]
        
        self.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
    func createPickerView () {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        
        categoryToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let categoryDoneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PostFieldViewController.done))
        categoryToolbar.setItems([categoryDoneButtonItem], animated: true)
        categoryTextField.inputAccessoryView = categoryToolbar
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return categoryData.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categoryData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = categoryData[row]
        
        roomString = categoryTextField.text!
        
        roomCheck()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.categoryTextField.endEditing(true)
    }
    
    @objc func done (){
        
        self.categoryTextField.endEditing(true)
    }
    
    
    func roomCheck () {
        
    
    
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
        
        var count = Int()
        let flag = self.loadDBModel.dataSets[sender.tag].likeFlagDic[userID]
        
        if flag == nil{
            
            count = self.loadDBModel.dataSets[sender.tag].likeCount + 1
            db.collection("\(roomString)").document().setData(["likeFlagDic":[userID:true]], merge: true)
            
        }else{
            
            if flag! as! Bool == true{
                
                count = self.loadDBModel.dataSets[sender.tag].likeCount - 1
                db.collection("\(roomString)").document().setData(["likeFlagDic":[userID:false]], merge: true)

            }else{
                
                count = self.loadDBModel.dataSets[sender.tag].likeCount + 1
                db.collection("\(roomString)").document().setData(["likeFlagDic":[userID:true]], merge: true)

            }
            
        }
    
        //count情報を送信
        db.collection("\(roomString)").document(loadDBModel.dataSets[sender.tag].userID).updateData(["like":count], completion: nil)
        tableView.reloadData()
        
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
