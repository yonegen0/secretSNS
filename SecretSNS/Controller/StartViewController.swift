//
//  StartViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/02/01.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    
    
    @IBOutlet var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //少し縮小するアニメーション
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }, completion: { (Bool) in
                        
                       })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 1.0,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 1.9, y: 1.9)
                        self.logoImageView.alpha = 0
                       }, completion: { (Bool) in
                        self.logoImageView.removeFromSuperview()
                        
                        if Auth.auth().currentUser?.uid != nil {
                            
                            let tabVC = self.storyboard?.instantiateViewController(identifier: "tabVC")
                            tabVC?.modalPresentationStyle = .fullScreen
                            self.present(tabVC!, animated: false, completion: nil)
                            
                        } else {
                            
                            let LoginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                            LoginVC.modalPresentationStyle = .fullScreen
                            self.present(LoginVC, animated: false, completion: nil)
                        }
                       })
        
    }
    
}
