//
//  HomeViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 8/29/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import MJRefresh
import GoogleMobileAds


class PopulerViewController: BaseViewController {
    
    var fakeNavi: CommonMainNavigationView!
    
    var request:GADRequest!
    
    @IBOutlet weak var collectionViewStory: UICollectionView!
    var arrStory:[StoryInfoModel]? = [StoryInfoModel]()
 
    var currentPage:Int = 0
 
    var numAd:Int = 0
    var param:NSMutableDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request = GADRequest()
        self.setupLoadMoreAndPullRefresh()
        self.getDefaultData()
        
       
        
        
        
    }
    
    func getDefaultData() { // get hot book list
        if let item = getPriviosParam() {
            let url = String(format: "%@%@",BaseUrl,item.valueForKey(keycategoryparam) as? String ?? "")
           
            self.loadData(url   ,isRefresh: true)
            let title = item.valueForKey(keycategorynameparam)
            self.fakeNavi.stringDes = title as? String ?? ""
             self.fakeNavi.lblTitle.text = "Popular"
        }
        
    }
    
    func getPriviosParam() -> NSMutableDictionary?{
        param = NSMutableDictionary()
        
        param!.setValue( "/popular", forKey: keycategoryparam)
        param!.setValue( "All", forKey: keycategorynameparam)
 
        return param
        
    }
    
    func loadData(url:String , isRefresh:Bool )  {
        
        
        if self.collectionViewStory.mj_header.isRefreshing() == true {
            self.collectionViewStory.mj_header.endRefreshing()
        }
        if self.collectionViewStory.mj_footer.isRefreshing() == true {
            self.collectionViewStory.mj_footer.endRefreshing()
        }
        
        if isRefresh == true {
            self.collectionViewStory.setContentOffset(CGPointMake(0, -24), animated: true)
        }
      
        
        let param = NSMutableDictionary()
        param.setValue(url, forKey: keyUrl)
//        print("url")
//        print(url)
        BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
            if isRefresh == true {
                self?.arrStory?.removeAll(keepCapacity: false)
                
            }
            let doc = TFHpple(HTMLData: result)
            
            let elements = doc.searchWithXPathQuery("//div[@class='mangaresultitem']")
            
            for eleItem in elements {
                let e0 = eleItem as! TFHppleElement
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
                    //            print(e.attributes["class"])
                    //            print("e.raw")
                    //            print(e.content)
                    if e.attributes["class"]?.isEqualToString("mangaresultinner") == true   {
                        //                      print("e.content")
                        //                      print(e.content)
                        let itemStory = StoryInfoModel()
                        for eleItem1 in e.children {
                            let e1 =  eleItem1 as! TFHppleElement
                            if e1.attributes["class"]?.isEqualToString("imgsearchresults") == true   {
                                
                                if let href = e1.objectForKey("style") {
                                    
                                    let imgUrlArr = href.characters.split{$0 == "'"}.map(String.init)
                                    if imgUrlArr.count >= 2 {
                                        
                                        itemStory.storyImgUrl = imgUrlArr[1]
                                    }
                                    
                                }
                                
                            }else if  e1.attributes["class"]?.isEqualToString("result_info c2") == true  {
                                for eleItem2 in e1.children {
                                    let e2 =  eleItem2 as! TFHppleElement
                                    if e2.attributes["class"]?.isEqualToString("manga_name") == true{
                                        for eleItem3 in e2.children {
                                            let e3 =  eleItem3 as! TFHppleElement
                                            for eleItem4 in e3.children {
                                                let e5 =  eleItem4 as! TFHppleElement
                                                for eleItem6 in e5.children {
                                                    let e6 =  eleItem6 as! TFHppleElement
                                                    
                                                    if e6.raw != nil {
//                                                        print("e6.content")
//                                                        print(e6.raw)
                                                        if let href = e6.objectForKey("href") {
                                                            itemStory.storyUrl = href
                                                        }
                                                       
                                                    }
                                                }
                                                if e5.raw != nil {
//                                                  print("e5.content")
//                                                      print(e5.raw)
//                                                     if let href = e5.objectForKey("href") {
//                                                         itemStory.storyUrl = href
//                                                    }
                                                     itemStory.storyName = e5.content
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self?.arrStory?.append(itemStory)
                    }
                }
                
            }
 
            
            self?.collectionViewStory.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PopulerViewController {
    func goToSearch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchStoryViewController") as! SearchStoryViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToFilter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FilterPopularStoryViewController") as! FilterPopularStoryViewController
        vc.hidesBottomBarWhenPushed = true
        vc.param = self.param
        vc.block = {[weak self] (result)->() in
            self?.param = result
            let category =  result.valueForKey(keycategorynameparam) as? String
            self?.fakeNavi.stringDes = category  ?? ""
            let loseCase = category?.lowercaseString
            let path =  loseCase?.stringByReplacingOccurrencesOfString(" ", withString: "-")
            self?.currentPage = 0
            var url = "";
            if path != "all" {
                url = String(format: "%@/popular/%@/%d",BaseUrl, path ?? "",  (self?.currentPage)!*kPageNumber )
              
            }else{
                url = String(format: "%@/popular/%d",BaseUrl,  (self?.currentPage)!*kPageNumber )
                
            }
            
              self?.loadData(url,isRefresh: true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
extension PopulerViewController {
    override func setUpNavigationBar() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeightDiscoverNavibar + 20  )
        self.fakeNavi = CommonMainNavigationView(frame: CGRectMake(0, -20, self.view.frame.size.width, kHeightDiscoverNavibar + 20  ))
        //        print(self.fakeNavi.frame)
        self.navigationController?.navigationBar.addSubview(self.fakeNavi)
        self.fakeNavi.lblTitle.text =  "Discover"
        self.fakeNavi.rightBtn2.hidden = true
        self.fakeNavi.rightBtn1.hidden = true
        self.fakeNavi.naviHandleBlock = {[weak self] (type: NaviButtonClickType) -> () in
            if (type == .LeftFirst) {
                self?.goToFilter()
            }else if (type == .RightFirst) {
                self?.goToSearch()
                
            }else if (type == .RightSecond) {
                
            }
        }
        
        self.collectionViewStory.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.fakeNavi.hidden = false
          self.collectionViewStory.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionViewStory.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.fakeNavi.hidden = true
    }
}


extension PopulerViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    override func scrollToTop() {
        super.scrollToTop()
        self.collectionViewStory.setContentOffset(CGPointMake(0, -24), animated: true)
    }
    
    
    func setupLoadMoreAndPullRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
            let category =   self?.param?.valueForKey(keycategorynameparam) as? String
            let loseCase = category?.lowercaseString
            let path =  loseCase?.stringByReplacingOccurrencesOfString(" ", withString: "-")
            self?.currentPage = 0
            var url = "";
            if path != "" {
                url = String(format: "%@/popular/%@/%d",BaseUrl, path ?? "",  (self?.currentPage)!*kPageNumber )
                
            }else{
                url = String(format: "%@/popular/%d",BaseUrl,  (self?.currentPage)!*kPageNumber )
                
            }
            self?.loadData(url, isRefresh: false)
            
            })
        header.lastUpdatedTimeLabel!.hidden = true
        header.setTitle("Release To Refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Refreshing Data...", forState: MJRefreshState.Refreshing)
        header.setTitle("Pull To Refresh", forState: MJRefreshState.Idle)
        self.collectionViewStory.mj_header = header
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] () -> Void in
            if let owner  = self {
               
                let category =   self?.param?.valueForKey(keycategorynameparam) as? String
                let loseCase = category?.lowercaseString
                let path =  loseCase?.stringByReplacingOccurrencesOfString(" ", withString: "-")
                self?.currentPage += 1
                var url = "";
                if path != "all" {
                    url = String(format: "%@/popular/%@/%d",BaseUrl, path ?? "",  (self?.currentPage)!*kPageNumber )
                    
                }else{
                    url = String(format: "%@/popular/%d",BaseUrl,  (self?.currentPage)!*kPageNumber )
                    
                }
                owner.loadData(url, isRefresh: false)
            }
            
            })
        
        footer.setTitle("Loading Data...", forState: MJRefreshState.Refreshing)
        footer.setTitle("No More Data...", forState: MJRefreshState.NoMoreData)
        footer.setTitle(" ", forState: MJRefreshState.Idle)
        self.collectionViewStory.mj_footer = footer
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.arrStory?.count ?? 0
        //        print("numbook: \(count)")
        numAd = count/knumAdd
        return (count + numAd) ?? 0
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.item % knumAdd == 0  && indexPath.item > 0 {
            return CGSizeMake(self.view.frame.size.width - 40, self.view.frame.size.width - 40)
        }else{
            return CGSizeMake(self.view.frame.size.width/3 - 20, self.view.frame.size.width*1.45/3.0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionViewStory.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            if cell!.isKindOfClass(HomeCollectionViewCell) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("DetailInfoStoryViewController") as! DetailInfoStoryViewController
                let numAdCurrent =  indexPath.item/knumAdd
                let arrIndex = indexPath.item - numAdCurrent
                let storyInfo = self.arrStory![arrIndex]
                
                vc.storyFullInfo = StoryFullInfoModel()
                vc.storyFullInfo.storyImgUrl = storyInfo.storyImgUrl
                vc.storyFullInfo.storyName = storyInfo.storyName
                vc.storyFullInfo.storyUrl = storyInfo.storyUrl
                
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let numAdCurrent =  indexPath.item/knumAdd
        
        if indexPath.item % knumAdd == 0 &&   indexPath.item > 0{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeAdCollectionViewCell", forIndexPath: indexPath) as! HomeAdCollectionViewCell
            cell.adView.adUnitID = adUnitLarge
            cell.adView.rootViewController = self
            cell.adView.loadRequest(request)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCell", forIndexPath: indexPath) as! HomeCollectionViewCell
            
            let arrIndex = indexPath.item - numAdCurrent
            cell.updateData(self.arrStory![arrIndex])
            
            return cell
        }
    }
}
