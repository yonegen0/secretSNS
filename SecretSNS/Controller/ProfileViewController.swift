//
//  ProfileViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/24.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD


class ProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var sexTextField: UITextField!
    var agePickerView = UIPickerView()
    var sexPickerView = UIPickerView()
    let ageData = ["","10代","20代","30代","40代","50代","60代以上"]
    let sexData = ["","男性","女性"]
    let ageToolbar = UIToolbar()
    let sexToolbar = UIToolbar()
    
    let manImage:UIImage = UIImage(named: "man1")!
    let womanImage:UIImage = UIImage(named: "woman1")!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        
        self.ageTextField.inputView = agePickerView
        self.ageTextField.inputAccessoryView = ageToolbar
        self.sexTextField.inputView = sexPickerView
        self.sexTextField.inputAccessoryView = sexToolbar
    }
    
    @IBAction func update(_ sender: Any) {
        
        if userNameTextField.text! == "" || ageTextField.text! == "" || sexTextField.text! == "" {
            return
        }
        
        HUD.show(.progress)
        Auth.auth().signInAnonymously { (result, error) in
            if error != nil {
                return
            }
            
            let user = result?.user
            print(user.debugDescription)
            
            
            UserDefaults.standard.setValue(self.userNameTextField.text, forKey: "userName")
            UserDefaults.standard.setValue(self.ageTextField.text, forKey: "ageData")
            UserDefaults.standard.setValue(self.sexTextField.text, forKey: "sexData")
            UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "userID")
    
            
            HUD.hide()
            let ConVC = self.storyboard?.instantiateViewController(identifier: "ConVC") as! ConfigurationViewController
            ConVC.modalTransitionStyle = .coverVertical
            ConVC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(ConVC, animated: true, completion:nil)
           
        }
       
    }
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createPickerView () {
        
        agePickerView.delegate = self
        agePickerView.dataSource = self
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        
        
        ageToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let ageDoneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LoginViewController.done))
        ageToolbar.setItems([ageDoneButtonItem], animated: true)
        ageTextField.inputAccessoryView = ageToolbar
        
        
        sexToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let sexDoneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LoginViewController.done))
        sexToolbar.setItems([sexDoneButtonItem], animated: true)
        sexTextField.inputAccessoryView = sexToolbar
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == agePickerView {
            return ageData.count
        }else{
            return sexData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == agePickerView {
            return ageData[row]
        }else{
            return sexData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == agePickerView {
            ageTextField.text = ageData[row]
        }else{
            sexTextField.text = sexData[row]
        }
        if sexTextField.text == "女性" {
            profileImageView.image = womanImage
        } else if sexTextField.text == "男性"{
            profileImageView.image = manImage
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ageTextField.endEditing(true)
        self.sexTextField.endEditing(true)
        userNameTextField.resignFirstResponder()
    }
    
    
    @objc func done (){
        
        self.ageTextField.endEditing(true)
        self.sexTextField.endEditing(true)
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
