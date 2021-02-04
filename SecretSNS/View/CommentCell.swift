//
//  CommentCell.swift
//  SecretSNS
//
//  Created by 米津純生 on 2020/12/25.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userInforLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
