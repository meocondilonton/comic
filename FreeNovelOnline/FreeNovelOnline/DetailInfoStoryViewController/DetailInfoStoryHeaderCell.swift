//
//  DetailInfoStoryHeaderCell.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/5/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class DetailInfoStoryHeaderCell: UITableViewHeaderFooterView {


    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var lblTitleStory: UILabel!
    
    @IBOutlet weak var lblAuthorStory: FRHyperLabel!
    
    @IBOutlet weak var lblCategoryStory: FRHyperLabel!
    
    @IBOutlet weak var lblStatusSory: FRHyperLabel!
    
    @IBOutlet weak var lblSeriesStory: FRHyperLabel!
    
    @IBOutlet weak var lblAlterNameStory: UILabel!
    
 
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnRead: UIButton!

 
    
    private var block:((Int)->())?
    
    func updateData(info:StoryFullInfoModel , block:((Int)->())?){
        self.block = block
         self.lblTitleStory.text = info.storyName
        let originalUrl = String(format: "%@",info.storyImgUrl  ?? "")
        let imgCoverUrl = NSURL(string: originalUrl)
         self.imgCover.sd_setImageWithURL(imgCoverUrl, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.RetryFailed)
    
        let hyperTextColor = UIColor.blackColor()
        let hyperTextFont = UIFont.boldSystemFontOfSize(12)
        
        let nomalTextFont = UIFont.systemFontOfSize(12)
        
        let arrFont = [nomalTextFont, hyperTextFont]
        let arrColor = [textGrayColor,hyperTextColor]
        
       
        
        let arrAuthor:NSArray =  NSArray(arrayLiteral: "Author: ", info.storyAuthor?.itemName ?? "")
        let arrSeries:NSArray =  NSArray(arrayLiteral: "Reading Direction: ", info.storyReadingDerection ?? "")
        let arrStatus:NSArray =  NSArray(arrayLiteral: "Status: ", info.storyStatus?.itemName ?? "")
         let arrView:NSArray =  NSArray(arrayLiteral: "Alternate Name: ", info.storyAlterName  ?? "")
        
        let arrFontCategory = NSMutableArray()
        let arrColorCategory = NSMutableArray()
        let arrCategory = NSMutableArray()
         arrFontCategory.addObject(nomalTextFont)
         arrColorCategory.addObject(textGrayColor)
         arrCategory.addObject("Genre: ")
        if  info.storyCategory?.count > 0 {
        for item in info.storyCategory! {
            arrFontCategory.addObject(hyperTextFont)
            arrColorCategory.addObject(hyperTextColor)
            if item == info.storyCategory!.last {
                arrCategory.addObject(String(format: "%@",item.itemName ?? ""))
            }else{
                arrCategory.addObject(String(format: "%@, ",item.itemName ?? ""))
            }
        }
             self.lblCategoryStory.attributedText =  Utils.attributeStringForTexts(arrCategory, fonts: arrFontCategory as! [UIFont], colors: arrColorCategory as! [UIColor], separator: "")
        }
        self.lblAuthorStory.attributedText = Utils.attributeStringForTexts(arrAuthor, fonts: arrFont, colors: arrColor, separator: "")
        self.lblSeriesStory.attributedText =  Utils.attributeStringForTexts(arrSeries, fonts: arrFont, colors: arrColor, separator: "")
         self.lblStatusSory.attributedText =  Utils.attributeStringForTexts(arrStatus, fonts: arrFont, colors: arrColor, separator: "")
         self.lblAlterNameStory.attributedText =  Utils.attributeStringForTexts(arrView, fonts: arrFont, colors: arrColor, separator: "")
        
        
        
       
        self.btnRead.layer.cornerRadius = 5
        self.btnRead.layer.masksToBounds = true
        
        if info.isSaved == true {
           self.btnBookmark.hidden = true
        }else{
            
            self.btnBookmark.layer.cornerRadius = 5
            self.btnBookmark.layer.masksToBounds = true
            self.btnBookmark.hidden = false
        }
    }
   
    @IBAction func btnReadTouch(sender: AnyObject) {
        if self.block != nil {
            self.block!(0)
        }
    }
    
    @IBAction func btnBookmark(sender: AnyObject) {
        if self.block != nil {
            self.block!(1)
        }
    }
  
    

}
