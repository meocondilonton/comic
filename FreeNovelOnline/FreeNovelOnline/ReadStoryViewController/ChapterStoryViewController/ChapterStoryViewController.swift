//
//  ChapterStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/8/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import MFSideMenu
import GoogleMobileAds

class ChapterStoryViewController: BaseViewController ,SKPhotoBrowserDelegate{
    
    @IBOutlet weak var tbView: UITableView!
    
    var block:((Int)->())?
    var chapSelected:Int = 0
    var currentPhoto:Int = 0
    var arrPhoto:[SKPhoto]?
    var ws:LoadImgWebservice?
    var storyFullInfo:StoryFullInfoModel!
    var isFromLastRelease:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chapSelected = self.storyFullInfo.currentChapter
        self.currentPhoto =  self.storyFullInfo.storyChapter![self.chapSelected].imgOffset
        if isFromLastRelease == false {
        self.loadChapterData(String(format:"%@%@",BaseUrl, self.storyFullInfo.storyChapter![self.chapSelected].itemUrl!) )
            let moveToIndexPath = NSIndexPath(forRow: self.chapSelected, inSection: 0)
            self.tbView.scrollToRowAtIndexPath(moveToIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }else{
            self.tbView.setContentOffset(CGPointMake(0, CGFloat.max), animated: true)
        }
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChapter(arrChapter:[Item]?,chapSelected:Int, block:((Int)->())?){
        self.chapSelected = chapSelected
        self.currentPhoto = self.storyFullInfo.storyChapter![self.chapSelected].imgOffset
        self.block = block
       self.storyFullInfo.storyChapter = arrChapter
        self.tbView.reloadData()
    }
    
}

extension ChapterStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Back, vc: self)
        let titleStory = "Chapters"
        navigationItem.title = titleStory
        
    }
    
   override func btnBackTouch() {
    
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension ChapterStoryViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyFullInfo.storyChapter?.count ?? 0
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChapterTableViewCell", forIndexPath: indexPath) as! ChapterTableViewCell
        let arrIndex = indexPath.row
        cell.updateData(self.storyFullInfo.storyChapter?[arrIndex])
        if indexPath.row ==  self.chapSelected {
            cell.setCellSelect(true )
        }else{
            cell.setCellSelect(false )
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var idex = NSIndexPath(forRow:  self.chapSelected, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(idex) as? ChapterTableViewCell {
            cell.setCellSelect(false )

        }
          self.chapSelected = indexPath.row
         idex = NSIndexPath(forRow:  self.chapSelected, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(idex) as? ChapterTableViewCell {
            cell.setCellSelect(true )
            
        }
          self.currentPhoto = 0
          self.loadChapterData(String(format:"%@%@",BaseUrl, self.storyFullInfo.storyChapter![self.chapSelected].itemUrl!) )
    }
 
}


extension ChapterStoryViewController {
    
    func loadChapterData(url:String )  {
        let param = NSMutableDictionary()
        
        param.setValue(url , forKey: keyUrl)
//         ws = LoadImgWebservice()
         BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
            
            let doc = TFHpple(HTMLData: result)
            
            //read top
            let elements = doc.searchWithXPathQuery("//select[@id='pageMenu']")
           
            self?.storyFullInfo.storyChapter![self?.chapSelected ?? 0].arrImg = [String]()
            for eleItem in elements {
                let e = eleItem as! TFHppleElement
                for item in e.children {
                    
                    if let link = item.objectForKey("value") {
                         self?.storyFullInfo.storyChapter![self?.chapSelected ?? 0].arrImg?.append(link as! String)
                        
                    }
                }
            }
            
            self?.loadPhotoBrowser()
        }
        
        
        
    }
    
    
    func loadPhotoBrowser(){
               arrPhoto = [SKPhoto]()
        for item in (self.storyFullInfo.storyChapter![self.chapSelected].arrImg)! {
           
            let photoTemp = SKPhoto(url: item)
            arrPhoto?.append(photoTemp)
        }
        if arrPhoto?.count > 0 {
        let photoBrowser = SKPhotoBrowser(photos: arrPhoto!)
        photoBrowser.initializePageIndex(self.currentPhoto)
        photoBrowser.delegate = self
        self.presentViewController(photoBrowser, animated: true) {
            
        }
        }
    }
    
    func loadToCacheImg(arrPath:[SKPhoto]){
        let group = dispatch_group_create()
       
        for item in arrPath {
             dispatch_group_enter(group)
             item.loadUnderlyingImageAndNotify({
                  print("loadToCacheImg" + item.photoURL)
                 dispatch_group_leave(group)
             })
 
            
            }
 
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            // This block will be executed when all tasks are complete
            print("loadToCacheImg complete")
           
        }
        }
    
    func willDismissAtPageIndex(index: Int) {
        print("dismis at \(index)")
        self.currentPhoto = index
        self.storyFullInfo.currentChapter = self.chapSelected
        self.storyFullInfo.storyChapter![self.chapSelected].imgOffset = self.currentPhoto
        DatabaseHelper.shareInstall().inSertStoryFullInfoSaved(self.storyFullInfo)
        
    }
    func didScrollToIndex(index: Int) {
          print("scroll to  \(index)")
         self.currentPhoto = index
    }
}















