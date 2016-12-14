//
//  StoryTableViewCell.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/11/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class StoryTableViewCell3: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
   
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var lblChap: UILabel!
    @IBOutlet weak var lblRelativeDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func uodateData( data:StoryInfoModel ) {
        
        self.lblRelativeDate.text = data.storyDateUpdate ?? ""
        self.lblRelativeDate.textColor = textGrayColor
        self.lblContent.text =  data.storyName ?? ""
        self.lblChap.text = data.storyRecentUpdate ?? ""
        self.lblChap.textColor = textGrayColor
    }
}
