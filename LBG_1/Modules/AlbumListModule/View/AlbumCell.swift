//
//  AlbumCell.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 13/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
	
	@IBOutlet weak var imgvw_icon: UIImageView!
	@IBOutlet weak var lbl_name: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
