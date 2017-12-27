//
//  FreewordTableViewCell.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/17.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit

class FreewordTableViewCell: UITableViewCell {
    @IBOutlet weak var freeword: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
