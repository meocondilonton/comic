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

let kHeightDiscoverNavibar:CGFloat = 78
class HomeViewController: BaseViewController {
    
    var fakeNavi: CommonMainNavigationView!
    
    var request:GADRequest!
    
    @IBOutlet weak var collectionViewStory: UICollectionView!
    var arrStory:[StoryInfoModel]? = [StoryInfoModel]()
    var previousLink:String = ""
    var nextLink:String = ""
    var currentPage:Int = 1
    
    var param:NSMutableDictionary?
//    var currentLink:String = ""
    var numAd:Int = 0
    
    var catelogyName = ["37":"Action" ,"36":"Adventure" ,"35":"Comedy" ,"34":"Demons" ,"33":"Drama" ,"32":"Ecchi" ,"31":"Fantasy" ,"30":"Gender Bender" ,"29":"Harem" ,"28":"Historical" ,"27":"Horror" ,"26":"Josei" ,"25":"Magic" ,"24":"Martial Arts" ,"23":"Mature" ,"22":"Mecha" ,"21":"Molitary" ,"20":"Mystery" ,"19":"One Shot" ,"18":"Psychological" ,"17":"Romance" ,"16":"School Life" ,"15":"Sci-Fi" ,"14":"Seinen" ,"13":"Shoujo" ,"12":"Shoujoai" ,"11":"Shounen" ,"10":"Shounenai" ,"9":"Slice of Life" ,"8":"Smut" ,"7":"Sports" ,"6":"Super Power" ,"5":"Supernatural" ,"4":"Tragedy" ,"3":"Vampire" ,"2":"Yaoi" ,"1":"Yuri"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request = GADRequest()
        self.setupLoadMoreAndPullRefresh()
        self.getDefaultData()
       
        self.collectionViewStory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
       
    }

    func getDefaultData() { // get hot book list
        
        
        self.param = self.getPriviosParam()
        self.loadData(self.param!,isRefresh: true)
        self.updateHeader(false, isTittle: false)
        
    }
    
    func updateHeader( isSearch:Bool, isTittle:Bool){
        
        if isSearch == true {
             let keyWord = self.param?.valueForKey(keywordparam) as? String
             self.fakeNavi.stringDes =  keyWord!
        }else{
            var condition = "Filter by: "
            if let string = self.param?.valueForKey(keycategorynameparam) as? String {
                
                condition.appendContentsOf(string)
            }
            
            if let string = self.param?.valueForKey(keytypeparam)  as? String{
                if string == "0" {
                     condition.appendContentsOf(", Both")
                }else if string == "1" {
                     condition.appendContentsOf(", Manhwa")
                }else if string == "2" {
                     condition.appendContentsOf(", Manga")
                }
                 
            }
           
            if let string = self.param?.valueForKey(keystatusparam)  as? String{
                if string == "0" {
                     condition.appendContentsOf(", Both")
                }else if string == "1" {
                     condition.appendContentsOf(", Ongoing")
                }else if string == "2" {
                     condition.appendContentsOf(", Complete")
                }
                
            }
      
            if let string = self.param?.valueForKey(keyorderparam)  as? String{
                if string == "0" {
                      condition.appendContentsOf(", Similarity")
                }else if string == "1" {
                       condition.appendContentsOf(", Alphabetical")
                }else if string == "2" {
                       condition.appendContentsOf(", Popularity")
                }
                
            }
            
             self.fakeNavi.stringDes = condition
        }
        
    }
    
    func getPriviosParam() -> NSMutableDictionary{
        var pa = Utils.getFilterParams()
        if pa == nil {
            pa = NSMutableDictionary()
            
            Utils.saveFilterParams(pa!)
            return pa!
        }else{
            
            return pa!
        }
    }
    
    func loadData(param:NSMutableDictionary   , isRefresh:Bool )  {
        let rd = param.valueForKey(keytypeparam) as? String
        let cate = param.valueForKey(keycategoryparam) as? String
        let status = param.valueForKey(keystatusparam) as? String
        let order = param.valueForKey(keyorderparam) as? String
        let url = String(format:UrlSearch,"",rd ?? "",status ?? "",order ?? "",cate ?? "",self.currentPage)
 //        if self.currentLink == url {
//            if self.collectionViewStory.mj_header.isRefreshing() == true {
//                self.collectionViewStory.mj_header.endRefreshing()
//            }
//            if self.collectionViewStory.mj_footer.isRefreshing() == true {
//                self.collectionViewStory.mj_footer.endRefreshing()
//            }
//            return
//        }else{
//            self.currentLink = url
//        }
        
        if self.collectionViewStory.mj_header.isRefreshing() == true {
            self.collectionViewStory.mj_header.endRefreshing()
        }
        if self.collectionViewStory.mj_footer.isRefreshing() == true {
            self.collectionViewStory.mj_footer.endRefreshing()
        }
      
        if isRefresh == true {
            self.collectionViewStory.setContentOffset(CGPointMake(0, -20), animated: true)
        }
        //test
//        if appdelegate.isTest  == true {
//            self.arrStory?.removeAll()
//            self.arrStory = self.arrTest()
//            self.collectionViewStory.reloadData()
//            
//            return
//        }
        
        let paramSend = NSMutableDictionary()
        paramSend.setValue(url, forKey: keyUrl)
        print("url")
        print(url)
       BaseWebservice.shareInstance().getData(paramSend, isShowIndicator: true) {[weak self] (result) in
        if isRefresh == true {
            self?.arrStory?.removeAll(keepCapacity: false)
            
        }
        let doc = TFHpple(HTMLData: result)
        
     
            let elements = doc.searchWithXPathQuery("//div[@class='mangaresultitem']")
//             print("elements")
//            print(elements)
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
                                
                            }else if  e1.attributes["class"]?.isEqualToString("result_info c4") == true  {
                                for eleItem2 in e1.children {
                                    let e2 =  eleItem2 as! TFHppleElement
                                    if e2.attributes["class"]?.isEqualToString("manga_name") == true{
                                        for eleItem3 in e2.children {
                                            let e3 =  eleItem3 as! TFHppleElement
                                            for eleItem4 in e3.children {
                                                let e5 =  eleItem4 as! TFHppleElement
                                                print("e5.content")
                                                 if e5.raw != nil {
                                                print(e5.raw)
                                                }
                                                for eleItem6 in e5.children {
                                                    let e6 =  eleItem6 as! TFHppleElement
                                                    
                                                    if e6.raw != nil {
                                                        print("e6.content")
                                                        print(e6.raw)
                                                        if let href = e6.objectForKey("href") {
                                                            itemStory.storyUrl = href
                                                        }
                                                        
                                                    }
                                                }
                                                if e5.raw != nil {
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

extension HomeViewController {
    func goToSearch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchStoryViewController") as! SearchStoryViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToFilter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FilterStoryViewController") as! FilterStoryViewController
        vc.hidesBottomBarWhenPushed = true
        vc.param = self.param
        vc.block = {[weak self] (result)->() in
            
            self?.param = result
            self?.loadData(result,isRefresh: true)
//            let pa = NSMutableDictionary()
//            pa.setObject(result, forKey: "story")
//            Utils.saveFilterParams(pa)
//            let title = result.storyName ?? ""
//            self?.fakeNavi.lblTitle.text =  title
            self?.updateHeader(false, isTittle: false)
            self?.collectionViewStory.scrollsToTop = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func arrTest()->[StoryInfoModel]{
//         var result = [StoryInfoModel]()
//        
//        let itemNew = StoryInfoModel()
//        itemNew.storyName = "Airport"
//        itemNew.storyUrl = "/241269-airport.html"
//        itemNew.storyImgUrl = "/uploads/truyen/Airport.jpg"
//        result.append(itemNew)
//        
//        let itemNew2 = StoryInfoModel()
//        itemNew2.storyName = "The Historian"
//        itemNew2.storyUrl = "/241337-the-historian.html"
//        itemNew2.storyImgUrl = "/uploads/truyen/The-Historian.jpg"
//        result.append(itemNew2)
//        
//        let itemNew3 = StoryInfoModel()
//        itemNew3.storyName = "Teenage Mermaid"
//        itemNew3.storyUrl = "/241217-teenage-mermaid.html"
//        itemNew3.storyImgUrl = "/uploads/truyen/Teenage-Mermaid.jpg"
//        result.append(itemNew3)
//        
//        let itemNew4 = StoryInfoModel()
//        itemNew4.storyName = "Our Lady of Darkness"
//        itemNew4.storyUrl = "/241960-our-lady-of-darkness.html"
//        itemNew4.storyImgUrl = "/uploads/truyen/Our-Lady-of-Darkness.jpg"
//        result.append(itemNew4)
//        
//        let itemNew5 = StoryInfoModel()
//        itemNew5.storyName = "Boy's Life"
//        itemNew5.storyUrl = "/241659-boys-life.html"
//        itemNew5.storyImgUrl = "/uploads/truyen/Boys-Life.jpg"
//        result.append(itemNew5)
//        
//        let itemNew6 = StoryInfoModel()
//        itemNew6.storyName = "Of Swine and Roses"
//        itemNew6.storyUrl = "/241518-of-swine-and-roses.html"
//        itemNew6.storyImgUrl = "/uploads/truyen/Of-Swine-and-Roses.jpg"
//        result.append(itemNew6)
//        
//        let itemNew7 = StoryInfoModel()
//        itemNew7.storyName = "Questing Beast"
//        itemNew7.storyUrl = "/241519-questing-beast.html"
//        itemNew7.storyImgUrl = "/uploads/truyen/Questing-Beast.jpg"
//        result.append(itemNew7)
//        
//        return result
//    }
    
    
}
extension HomeViewController {
    override func setUpNavigationBar() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeightDiscoverNavibar + 20  )
        self.fakeNavi = CommonMainNavigationView(frame: CGRectMake(0, -20, self.view.frame.size.width, kHeightDiscoverNavibar + 20  ))
//        print(self.fakeNavi.frame)
        self.navigationController?.navigationBar.addSubview(self.fakeNavi)
        self.fakeNavi.lblTitle.text =  "Discover"
        self.fakeNavi.naviHandleBlock = {[weak self] (type: NaviButtonClickType) -> () in
            if (type == .LeftFirst) {
                  self?.goToFilter()
            }else if (type == .RightFirst) {
                  self?.goToSearch()
               
            }else if (type == .RightSecond) {
            
            }
        }
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.fakeNavi.hidden = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.fakeNavi.hidden = true
    }
}


extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    func setupLoadMoreAndPullRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
                self?.getDefaultData()
            })
        header.lastUpdatedTimeLabel!.hidden = true
        header.setTitle("Release To Refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Refreshing Data...", forState: MJRefreshState.Refreshing)
        header.setTitle("Pull To Refresh", forState: MJRefreshState.Idle)
        self.collectionViewStory.mj_header = header
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] () -> Void in
            if let owner  = self {
//                 owner.loadData(owner.nextLink, isRefresh: false)
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
        numAd = count/12
        return (count + numAd) ?? 0
 
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.item % 12 == 0  && indexPath.item > 0 {
             return CGSizeMake(self.view.frame.size.width - 40, self.view.frame.size.width - 40)
        }else{
            return CGSizeMake(self.view.frame.size.width/3 - 20, self.view.frame.size.width*1.25/3.0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
         let cell = self.collectionViewStory.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            if cell!.isKindOfClass(HomeCollectionViewCell) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("DetailInfoStoryViewController") as! DetailInfoStoryViewController
                  let numAdCurrent =  indexPath.item/12
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
          let numAdCurrent =  indexPath.item/12
        
        if indexPath.item % 12 == 0 &&   indexPath.item > 0{
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
