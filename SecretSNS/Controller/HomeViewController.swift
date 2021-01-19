//
//  HomeViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2020/12/30.
//

import UIKit
import Firebase
import ViewAnimator
import ActiveLabel

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    let roomDataModel = RoomDataModel()
    var roomData = [String]()
    
    var loadDBModel = LoadDBModel()
    var db = Firestore.firestore()
    
    
    @IBOutlet var tableView: UITableView!
       
    @IBOutlet var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        roomData = roomDataModel.roomData
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
       
        tableView.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 10))]

        UIView.animate(views: tableView.visibleCells, animations: animation, completion:nil)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.postButton.layer.masksToBounds = true
        self.postButton.layer.cornerRadius = 30
        
    }
   
    @IBAction func PostButton(_ sender: Any) {
        
        let postVC = self.storyboard?.instantiateViewController(identifier: "postVC") as! PostFieldViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
        //postVC.modalTransitionStyle = .coverVertical
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
        roomLabel.text = roomData[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        let selectVC = self.storyboard?.instantiateViewController(identifier: "selectVC") as! SelectViewController
        selectVC.roomNumber = indexPath.row
        selectVC.modalTransitionStyle = .partialCurl
        selectVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(selectVC, animated: true, completion:nil)

        
        
    }
}
