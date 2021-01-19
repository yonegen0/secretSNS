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

class CommentViewController: UIViewController {
    
    var docID = String()
    
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    var roomString = String()
    let manImage:UIImage = UIImage(named: "man2")!
    let womanImage:UIImage = UIImage(named: "woman2")!
    
    var userName = String()
    var ageData = String()
    var sexData = String()
    var comment = String()
    var count = Int()
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userInforLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentStart()
        
        // Do any additional setup after loading the view.
    }
    
    
    func commentStart () {
        if sexData == "女性" {
            profileImageView.image = womanImage
        } else if sexData == "男性"{
            profileImageView.image = manImage
        }
        
        userNameLabel.text = userName
        userInforLabel.text = ageData + sexData
        commentLabel.text = comment
        countLabel.text = String(count)
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
