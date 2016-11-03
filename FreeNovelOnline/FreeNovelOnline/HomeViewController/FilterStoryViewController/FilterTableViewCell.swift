//
//  FilterTableViewCell.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 11/2/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var headerName:UILabel!
    @IBOutlet weak var tagView:TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
