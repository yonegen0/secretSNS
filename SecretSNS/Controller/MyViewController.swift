//
//  MyViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/02/02.
//

import UIKit
import Firebase
import ViewAnimator
import ActiveLabel

class MyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    let roomDataModel = RoomDataModel()
    var roomData = [String]()
    var userID = String()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "userID") != nil {
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }

        
        tableView.delegate = self
        tableView.dataSource = self
        
        roomData = roomDataModel.roomData
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 10))]

        UIView.animate(views: tableView.visibleCells, animations: animation, completion:nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //room名
        let roomLabel = cell.contentView.viewWithTag(1) as! UILabel
        let roomImage = cell.contentView.viewWithTag(2) as! UIImageView
        roomLabel.text = roomData[indexPath.row]
        var randomColor: UIColor {
           let r = CGFloat.random(in: 0 ... 255) / 255.0
           let g = CGFloat.random(in: 0 ... 255) / 255.0
           let b = CGFloat.random(in: 0 ... 255) / 255.0
           return UIKit.UIColor(red: r, green: g, blue: b, alpha: 1.0)
       }
        roomImage.tintColor = randomColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        let seeVC = self.storyboard?.instantiateViewController(identifier: "seeVC") as! SeeViewController
        seeVC.roomNumber = indexPath.row
        seeVC.userID = userID
        seeVC.FieldData = "userID"
        seeVC.modalTransitionStyle = .flipHorizontal
        seeVC.modalPresentationStyle = .fullScreen
        
        self.present(seeVC, animated: true, completion:nil)
        
    }
}
