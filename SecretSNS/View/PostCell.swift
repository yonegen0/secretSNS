///Users/yonegen/Dropbox/アプリ/SecretSNS/SecretSNS/View/PostCell.swift
//  PostCell.swift
//  SecretSNS
//
//  Created by 米津純生 on 2020/12/25.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var commentButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userInforLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    @IBOutlet var BestComment: UILabel!
    @IBOutlet var Number1: UIImageView!
    @IBOutlet var CMImageView: UIImageView!
    @IBOutlet var CMuserInforLabel: UILabel!
    @IBOutlet var CMuserNameLabel: UILabel!
    @IBOutlet var CMcommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
