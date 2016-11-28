//
//  DetailInfoStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/5/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds

class DetailInfoStoryViewController: BaseViewController {
    
    @IBOutlet weak var contraiHeightAd: NSLayoutConstraint!
    @IBOutlet weak var adView: GADNativeExpressAdView!
    @IBOutlet weak var tbView: UITableView!
    
    var request:GADRequest!
    
    var storyFullInfo:StoryFullInfoModel!
    var header:DetailInfoStoryHeaderCell!
    var footer:DetailInfoStoryFootererCell!
    var isFromLastRelease:Bool = false
    
    var downloadProcess:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request = GADRequest()
        
        
        self.tbView.registerNib(UINib(nibName: "DetailInfoStoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DetailInfoStoryHeaderCell")
        self.tbView.registerNib(UINib(nibName: "DetailInfoStoryFootererCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DetailInfoStoryFootererCell")
        
        self.compareWithSavedDatabse()
        
        
        
    }
    
    func compareWithSavedDatabse(){
        
        let storySaved =  DatabaseHelper.shareInstall().getStoryFullInfo( (self.storyFullInfo?.storyName)!)
        if storySaved != nil {
            self.storyFullInfo = storySaved
        }
        if self.storyFullInfo.isSaved == false {
            self.loadData()
        }else{
            self.tbView.reloadData()
        }
    }
    
    
    func loadData(){
        let param = NSMutableDictionary()
        let url = String(format: "%@%@",BaseUrl,self.storyFullInfo.storyUrl ?? "")
        
        param.setValue(url , forKey: keyUrl)
        BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
            
            let doc = TFHpple(HTMLData: result)
            
            //read top
            let elements = doc.searchWithXPathQuery("//div[@id='mangaproperties']")
            for eleItem in elements {
                let e = eleItem as! TFHppleElement
                for item in e.children {
                    if let temp =  item as? TFHppleElement {
//                        print("temp")
                        if temp.attributes["id"]?.isEqualToString("latestchapters") == true{
                            break
                        }
                        for item2 in temp.children {
                            if let temp3 =  item2 as? TFHppleElement {
 
                                if temp3.children.count >= 4 {
                                    if let temp4 =  temp3.children[1] as? TFHppleElement {
//                                        print("temp4")
//                                        print(temp4.content)
                                        if temp4.content == "Alternate Name:" {
                                            if let temp4a = temp3.children[3] as? TFHppleElement {
                                                self?.storyFullInfo.storyAlterName = temp4a.content ?? ""
//                                                print("temp4a")
//                                                print(temp4a.content)
                                            }
                                        }else if temp4.content == "Status:" {
                                            if let temp4a = temp3.children[3] as? TFHppleElement {
                                                self?.storyFullInfo.storyStatus = Item()
                                                   self?.storyFullInfo.storyStatus?.itemName = temp4a.content ?? ""
//                                                print("temp4a")
//                                                print(temp4a.content)
                                            }
                                        }else if temp4.content == "Author:" {
                                            if let temp4a = temp3.children[3] as? TFHppleElement {
                                                self?.storyFullInfo.storyAuthor = Item()
                                                self?.storyFullInfo.storyAuthor?.itemName = temp4a.content ?? ""
//                                                print("temp4a")
//                                                print(temp4a.content)
                                            }
                                        }else if temp4.content == "Reading Direction:" {
                                            if let temp4a = temp3.children[3] as? TFHppleElement {
                                                
                                                self?.storyFullInfo.storyReadingDerection = temp4a.content ?? ""
//                                                print("temp4a")
//                                                print(temp4a.content)
                                            }
                                        }else if temp4.content == "Genre:" {
                                            if let temp4a = temp3.children[3] as? TFHppleElement {
//                                                 print("temp4")
//                                                if temp4a.raw != nil {
//                                                    print(temp4a.raw)
//                                                }
                                                self?.storyFullInfo.storyCategory = [Item]()
                                                for item5 in temp4a.children {
                                                        if let temp5 =  item5 as? TFHppleElement {
//                                                            print("temp5")
//                                                            if temp5.raw != nil {
//                                                            print(temp5.raw)
//                                                            }
                                                            if let link = temp5.objectForKey("href") {
                                                                let item = Item()
                                                                item.itemUrl = link
                                                                item.itemName = temp5.content
                                                                
                                                                  self?.storyFullInfo.storyCategory?.append(item)
//                                                                print("link")
//                                                                print(link)
//                                                                print("temp5.content")
//                                                                print(temp5.content)
                                                            }
                                                            
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
      
            }
            
            //read img
            let elementsImg = doc.searchWithXPathQuery("//div[@id='mangaimg']")
            self?.storyFullInfo.storyChapter = [Item]()
            for eleItem in elementsImg {
                let e = eleItem as! TFHppleElement
               
                for item in e.children {
                    if let temp =  item as? TFHppleElement {
                         if let link = temp.objectForKey("src") {
//                             print(link)
                            self?.storyFullInfo.storyImgUrl = link
                        }
                    }
                }
            }
            
            //read description
            let elementsDescription = doc.searchWithXPathQuery("//div[@id='readmangasum']")
            
            for eleItem in elementsDescription {
                let e = eleItem as! TFHppleElement
                self?.storyFullInfo.storyDescription = e.content
            }
            
            
            //read bot
            let elementsBot = doc.searchWithXPathQuery("//div[@id='chapterlist']")
              self?.storyFullInfo.storyChapter = [Item]()
            for eleItem in elementsBot {
                let e = eleItem as! TFHppleElement
                    for item in e.children {
                    if let temp =  item as? TFHppleElement {
                        for item2 in temp.children {
                            if let temp2 =  item2 as? TFHppleElement {
                                for item3 in temp2.children {
                                    if let temp3 =  item3 as? TFHppleElement {
                                        for item4 in temp3.children {
                                            if let temp4 =  item4 as? TFHppleElement {
//                                                print("temp4")
//                                                if temp4.raw != nil {
//                                                    print(temp4.raw)
//                                                }
                                                 if let link = temp4.objectForKey("href") {

                                                    let trimmed = (temp3.content as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//                                                    print("trimmed")
//                                                    print(trimmed)
                                                    let itemModel =  Item()
                                                     itemModel.itemName = trimmed
                                                     itemModel.itemUrl = link
                                                      self?.storyFullInfo.storyChapter?.append(itemModel)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
         self?.tbView.reloadData()
        }
        
    }
    
    func readStory(){
                if self.storyFullInfo.storyChapter == nil {
                    return
                }
 
        
        self.storyFullInfo.timeSaved = NSDate().timeIntervalSince1970
        self.storyFullInfo.storyIsRead = true
        DatabaseHelper.shareInstall().inSertStoryFullInfoSaved(self.storyFullInfo)
 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ChapterStoryViewController") as! ChapterStoryViewController
        vc.navigationController?.hidesBarsOnTap = true
        vc.hidesBottomBarWhenPushed = true
        vc.isFromLastRelease = self.isFromLastRelease
        vc.chapSelected = 1
        vc.storyFullInfo = self.storyFullInfo
        vc.block = {[weak self] (index) in
            if index < self?.storyFullInfo?.storyChapter?.count {
                
            }
        }
       
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveStory(){
        self.downloadProcess = 0
        if self.storyFullInfo.storyChapter == nil {
            return
        }
        self.storyFullInfo.isSaved = true
        DatabaseHelper.shareInstall().inSertStoryFullInfoSaved(self.storyFullInfo)
        
        
        let dispatch_group = dispatch_group_create()
        
        SVProgressHUD.showProgress(0, status: "Loading" ,maskType:.Gradient )
        var i:Float = 0
        for item in self.storyFullInfo.storyChapter! {
            i += 1
            dispatch_group_enter(dispatch_group)
            let param = NSMutableDictionary()
            
            let url = String(format: "%@%@",BaseUrl,item.itemUrl ?? "")
            param.setValue(url , forKey: keyUrl)
            param.setValue("\(i)" , forKey: "index")
            BaseWebservice().getData(param, isShowIndicator: false, block: {[weak self] (result) in
                dispatch_group_leave(dispatch_group)
                if let owner = self {
                    owner.downloadProcess += Float(( 1 / Float(owner.storyFullInfo.storyChapter!.count))   )
//                    print( owner.downloadProcess)
                    
                    SVProgressHUD.showProgress( owner.downloadProcess, status: "Loading" ,maskType:.Gradient)
                }
                })
        }
        
        
        dispatch_group_notify(dispatch_group, dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DetailInfoStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Back, vc: self)
        let titleStory = self.storyFullInfo.storyName ?? ""
        navigationItem.title = titleStory
        
    }
}

extension DetailInfoStoryViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return self.view.frame.size.width
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.header = self.tbView.dequeueReusableHeaderFooterViewWithIdentifier("DetailInfoStoryHeaderCell") as! DetailInfoStoryHeaderCell
        if self.storyFullInfo.isSaved {
           
        }
        header?.updateData(self.storyFullInfo) { [weak self](type) in
            if type == 0 {
                self?.readStory()
            }else{
                self?.saveStory()
            }
        }
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.width
    }
    
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.footer = self.tbView.dequeueReusableHeaderFooterViewWithIdentifier("DetailInfoStoryFootererCell") as! DetailInfoStoryFootererCell
        self.footer.adView.adUnitID = adUnitLarge
        self.footer.adView.rootViewController = self
        self.footer.adView.loadRequest(request)
        return footer
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailInfoStoryTableViewCell", forIndexPath: indexPath) as! DetailInfoStoryTableViewCell
        cell.updateData(self.storyFullInfo.storyDescription ?? "")
        return cell
    }
}





