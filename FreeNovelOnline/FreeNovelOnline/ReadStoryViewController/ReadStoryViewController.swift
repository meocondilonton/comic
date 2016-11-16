//
//  ViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 8/18/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import MJRefresh
import MFSideMenu



class ReadStoryViewController: BaseViewController , SKPhotoBrowserDelegate {
   
    
    
 
    var dicSetting:NSMutableDictionary!
    var currentFonSize:Int = 100
    var currentTheme:Int = ThemeStyle.White.rawValue
    var currentLight:Float = 1
    var chapterIndex = 0
    var storyFullInfo:StoryFullInfoModel!
    var chapterOffset:Double = 0
    var arrPhoto:[SKPhoto]?
  
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.chapterOffset = self.storyFullInfo.chapterOffset
        self.chapterIndex = self.storyFullInfo.currentChapter
        
     
        
       
        self.loadChapterData(String(format:"%@%@",BaseUrl,storyFullInfo.storyChapter![self.chapterIndex].itemUrl!) )
        
       
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReadStoryViewController.menuStateEventOccurred), name: MFSideMenuStateNotificationEvent, object: nil)

  
    }
    
    func hideNavigation(){
        self.navigationController?.setNavigationBarHidden( !(self.navigationController?.navigationBarHidden ?? true), animated: true)

    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKindOfClass(UITapGestureRecognizer.self) {
            otherGestureRecognizer.requireGestureRecognizerToFail(gestureRecognizer)
        }
        return true
    }
    
 
    
    func loadPhotoBrowser(){
        arrPhoto = [SKPhoto]()
        for item in (self.storyFullInfo?.storyChapter?[self.chapterIndex].arrImg)! {
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
    
    func loadChapterData(page:String )  {
        let param = NSMutableDictionary()
        let url = String(format: "%@%@",BaseUrl,self.storyFullInfo.storyChapter?[chapterIndex].itemUrl ?? "")
        
        param.setValue(url , forKey: keyUrl)
        BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
            
            let doc = TFHpple(HTMLData: result)
            
            //read top
            let elements = doc.searchWithXPathQuery("//select[@id='pageMenu']")
             self?.storyFullInfo.storyChapter?[self?.chapterIndex ?? 0].arrImg = [String]()
            for eleItem in elements {
                let e = eleItem as! TFHppleElement
                for item in e.children {
                  
                    if let link = item.objectForKey("value") {
                       self?.storyFullInfo.storyChapter?[self?.chapterIndex ?? 0].arrImg?.append(link as! String)
                      
//                        print("element")
//                        print(link)
                    }
                }
            }
//            self?.collectionView.reloadData()
              self?.loadPhotoBrowser()
        }
 
 
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
          NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension ReadStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.hidesBarsOnTap = false
//         appdelegate.slideMenuController.menuContainerViewController.panMode = MFSideMenuPanModeDefault
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        navigationController?.navigationBar.setDefault(UINavigationBar.State.LeftMenuAndSettingClosed, vc: self)
        let titleStory =  storyFullInfo.storyChapter?[self.chapterIndex].itemName ?? ""
        navigationItem.title = titleStory
      
        
    }
    
   override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//          self.navigationController?.hidesBarsOnTap = false
    }
    
   override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

//         appdelegate.slideMenuController.menuContainerViewController.panMode = MFSideMenuPanModeNone
    }
    
    override func btnLeftMenu() {
        super.btnLeftMenu()
//        self.menuContainerViewController.setMenuState(MFSideMenuStateLeftMenuOpen) {
//        
//        }
       
        
    }
    
    override func btnClosedTouch() {
        super.btnClosedTouch()
        self.navigationController?.popViewControllerAnimated(true)
//        self.storyFullInfo.currentChapter = self.chapterIndex
////        self.storyFullInfo.chapterOffset = Double(self.webView.scrollView.contentOffset.y)
//        DatabaseHelper.shareInstall().inSertStoryFullInfoSaved(self.storyFullInfo)
//        
//        self.dicSetting.setValue("\(self.currentFonSize)", forKey: keyFontSize)
//        self.dicSetting.setValue("\(self.currentLight)", forKey: keyLight)
//        self.dicSetting.setValue("\(self.currentTheme)", forKey: keyTheme)
//        Utils.saveSettingReaderParam(self.dicSetting)
//        let rand =  arc4random_uniform(10)
//        if rand >= 5 {
//            appdelegate.showInteristitial()
//        }
    }
    
    override func btnSettingTouch() {
        super.btnSettingTouch()
      
    }
}

//extension ReadStoryViewController : UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
// 
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return storyFullInfo?.storyChapter?[chapterIndex].arrImg?.count ?? 0
//    }
//    
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        return CGSizeMake(self.view.frame.size.width , self.view.frame.size.height  )
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ReadStoryCollectionViewCell", forIndexPath: indexPath) as! ReadStoryCollectionViewCell
//        if indexPath.item <= storyFullInfo?.storyChapter?[chapterIndex].arrImg?.count {
//            cell.updateData((storyFullInfo?.storyChapter?[chapterIndex].arrImg?[indexPath.item])!)
//        }
//        return cell
//    }
//    
//}






