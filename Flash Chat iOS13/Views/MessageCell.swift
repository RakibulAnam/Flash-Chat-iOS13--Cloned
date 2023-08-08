//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Jotno on 8/6/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    
    @IBOutlet weak var messagebubble: UIView!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //making messageBubble round
        
        messagebubble.layer.cornerRadius = messagebubble.frame.size.height / 5
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
