//
//  PostFieldViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/10.
//

import UIKit
import Firebase
import FirebaseAuth

class PostFieldViewController: UIViewController,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    
    @IBOutlet var categoryTextField: UITextField!
    var categoryPickerView = UIPickerView()
    var categoryToolbar = UIToolbar()
    var categoryData : [String] = [""]
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userInforLabel: UILabel!
   
    let roomDataModel = RoomDataModel()
    var roomString = String()
    
    let userDataModel = UserDataModel()
    var userName = String()
    var userID = String()
    var ageData = String()
    var sexData = String()
    
    
    let manImage:UIImage = UIImage(named: "man2")!
    let womanImage:UIImage = UIImage(named: "woman2")!
    
    
    @IBOutlet var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData()
        
        print(userID)
        
        categoryData +=  roomDataModel.roomData
        
        createPickerView()
        
        poststart()
        //テキストビューのデリゲート先にこのインスタンスを設定する。
        textView.delegate = self
        
        self.categoryTextField.inputView = categoryPickerView
        self.categoryTextField.inputAccessoryView = categoryToolbar
    }
    
    
    @IBAction func postButton(_ sender: Any) {
        if textView.text!.isEmpty && categoryTextField.text?.isEmpty == true {
            return
        }
        
        roomString = categoryTextField.text!
        
        print(roomString)
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, comment: textView.text!, ageData: ageData, sexData: sexData,likeCount: 0,likeFlagDic: [userID:false])
        sendDBModel.sendData(roomData: roomString)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func userData (){
        userDataModel.usercheck()
        
        userName = userDataModel.userName
        userID = userDataModel.userID
        ageData = userDataModel.ageData
        sexData = userDataModel.sexData
    }
        
    func poststart () {
        if sexData == "女性" {
            profileImageView.image = womanImage
        } else if sexData == "男性"{
            profileImageView.image = manImage
        }
        
        userNameLabel.text = userName
        userInforLabel.text = ageData + sexData
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
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
        self.categoryTextField.endEditing(true)
    }
    
    //「閉じるボタン」で呼び出されるメソッド
    @objc func onClickCloseButton(sender: UIButton) {
        //キーボードを閉じる
        textView.resignFirstResponder()
    }
    
    @objc func done (){
        
        self.categoryTextField.endEditing(true)
    }
    
}
