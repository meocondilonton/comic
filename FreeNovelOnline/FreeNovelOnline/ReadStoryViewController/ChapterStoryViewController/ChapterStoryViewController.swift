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
    var arrChapter:[Item]?
    var chapSelected:Int = 0
    var arrPhoto:[SKPhoto]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadChapterData(String(format:"%@%@",BaseUrl, arrChapter![self.chapSelected].itemUrl!) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChapter(arrChapter:[Item]?,chapSelected:Int, block:((Int)->())?){
        self.chapSelected = chapSelected
        self.block = block
        self.arrChapter = arrChapter
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
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Empty, vc: self)
        let titleStory = "Chapters"
        navigationItem.title = titleStory
        
    }
}

extension ChapterStoryViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChapter?.count ?? 0
        
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
        cell.updateData(self.arrChapter?[arrIndex])
        if indexPath.row ==  self.chapSelected {
            cell.setCellSelect(true )
        }else{
            cell.setCellSelect(false )
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          self.chapSelected = indexPath.row
          self.loadChapterData(String(format:"%@%@",BaseUrl, arrChapter![self.chapSelected].itemUrl!) )
    }
 
}


extension ChapterStoryViewController {
    
    func loadChapterData(url:String )  {
        let param = NSMutableDictionary()
        
        param.setValue(url , forKey: keyUrl)
        BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
            
            let doc = TFHpple(HTMLData: result)
            
            //read top
            let elements = doc.searchWithXPathQuery("//select[@id='pageMenu']")
           
            self?.arrChapter![self?.chapSelected ?? 0].arrImg = [String]()
            for eleItem in elements {
                let e = eleItem as! TFHppleElement
                for item in e.children {
                    
                    if let link = item.objectForKey("value") {
                         self?.arrChapter![self?.chapSelected ?? 0].arrImg?.append(link as! String)
                        
                    }
                }
            }
            
            self?.loadPhotoBrowser()
        }
        
        
        
    }
    
    
    func loadPhotoBrowser(){
        loadToCacheImg((self.arrChapter![self.chapSelected].arrImg)!)
        arrPhoto = [SKPhoto]()
        for item in (self.arrChapter![self.chapSelected].arrImg)! {
            //            let photoTemp = SKPhoto(url: "https://i4.mangareader.net/naruto/1/naruto-1564774.jpg" )
            let photoTemp = SKPhoto(url: item)
            arrPhoto?.append(photoTemp)
        }
        let photoBrowser = SKPhotoBrowser(originImage: UIImage(named:"placeholder")!, photos: arrPhoto!, animatedFromView: self.view)
        photoBrowser.initializePageIndex(0)
        photoBrowser.delegate = self
        self.presentViewController(photoBrowser, animated: true) {
            
        }
    }
    
    func loadToCacheImg(arrPath:[String]){
        let group = dispatch_group_create()
       
        for item in arrPath {
             dispatch_group_enter(group)
            
                Utils.fetchImage(item, block: { 
                     dispatch_group_leave(group)
                })
             
            }
 
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            // This block will be executed when all tasks are complete
            print("All tasks complete")
           
        }
        }
    
    
}















