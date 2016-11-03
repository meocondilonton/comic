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
    var currentLink:String = ""
    var numAd:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request = GADRequest()
        self.setupLoadMoreAndPullRefresh()
        self.getDefaultData()
       
        self.collectionViewStory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
       
    }

    func getDefaultData() { // get hot book list
        if let item = getPriviosParam() {
            let url = String(format: "%@%@",BaseUrl,item.storyUrl ?? "")
            self.loadData(url   ,isRefresh: true)
            let title = item.storyName ?? ""
            self.fakeNavi.lblTitle.text =  title
            
        }
        
    }
    
    func getPriviosParam() -> StoryInfoModel?{
        var pa = Utils.getFilterParams()
        if pa == nil {
            pa = NSMutableDictionary()
            let item = StoryInfoModel()
            item.storyImgUrl = ""
            item.storyUrl = ""
            item.storyName = "NEW BOOKS"
            pa!.setObject(item, forKey: "story")
            Utils.saveFilterParams(pa!)
            return item
        }else{
            let item = pa?.valueForKey("story") as? StoryInfoModel
            return item
        }
    }
    
    func loadData(url:String , isRefresh:Bool )  {
        if self.currentLink == url {
            if self.collectionViewStory.mj_header.isRefreshing() == true {
                self.collectionViewStory.mj_header.endRefreshing()
            }
            if self.collectionViewStory.mj_footer.isRefreshing() == true {
                self.collectionViewStory.mj_footer.endRefreshing()
            }
            return
        }else{
            self.currentLink = url
        }
        
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
        if appdelegate.isTest  == true {
            self.arrStory?.removeAll()
            self.arrStory = self.arrTest()
            self.collectionViewStory.reloadData()
            
            return
        }
        
        let param = NSMutableDictionary()
        param.setValue(url, forKey: keyUrl)
        print("url")
        print(url)
       BaseWebservice.shareInstance().getData(param, isShowIndicator: true) {[weak self] (result) in
        if isRefresh == true {
            self?.arrStory?.removeAll(keepCapacity: false)
            
        }
        let doc = TFHpple(HTMLData: result)
        if url == "http://www.readanybook.com/" {
        let elements = doc.searchWithXPathQuery("//div[@class='left-content']")
       
        for eleItem in elements {
            let e0 = eleItem as! TFHppleElement
            for eleItem0 in e0.children {
                 let e = eleItem0 as! TFHppleElement
            print(e.attributes["class"])
            print("e.raw")
            print(e.content)
                if e.attributes["class"]?.isEqualToString("books-list") == true   {
                      print("e.content")
                      print(e.content)
                    for eleItem1 in e.children {
                          let e1 =  eleItem1 as! TFHppleElement
                        if e1.attributes["class"]?.isEqualToString("book-list-slider") == true   {
                            print("e1.content")
                            print(e1.content)
                            for eleItem2 in e1.children {
                                let e2 =  eleItem2 as! TFHppleElement
                                if e2.attributes["class"]?.isEqualToString("viewport-outher") == true   {
                                    print("e2.content")
                                    print(e2.content)
                                        for eleItem3 in e2.children {
                                            let e3 =  eleItem3 as! TFHppleElement
                                            if e3.attributes["class"]?.isEqualToString("viewport") == true   {
                                                print("e3.content")
                                                print(e3.content)
                                                for eleItem4 in e3.children {
                                                    let e4 =  eleItem4 as! TFHppleElement
                                                    if e4.attributes["class"]?.isEqualToString("overview") == true   {
                                                         print("e4.content")
                                                         print(e4.content)
                                                        for eleItem5 in e4.children {
                                                            let e5 =  eleItem5 as! TFHppleElement
                                                            
                                                            for eleItem6 in e5.children {
                                                                let e6 =  eleItem6 as! TFHppleElement
                                                                
                                                               
                                                                if let href = e6.objectForKey("href") {
                                                                     let itemStory = StoryInfoModel()
                                                                     let urlString :String = href.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                                                                        itemStory.storyUrl = urlString
                                                                    
                                                                    for eleItem7 in e6.children {
                                                                        let e7 =  eleItem7 as! TFHppleElement
                                                                        if let src = e7.objectForKey("src") {
                                                                            let urlString :String = src.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                                                                            itemStory.storyImgUrl = urlString
                                                                            print("src")
                                                                            print(src)
                                                                        }
                                                                    }
                                                                     self?.arrStory?.append(itemStory)
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
            }
          
        }
        
        //paging
         let elementsPaging = doc.searchWithXPathQuery("//ul[@class='pg-ul']")
        for eleItem in elementsPaging {
            let e = eleItem as! TFHppleElement
           
            for item in e.children {

                for item2 in item.children {
                    let origin = item2.objectForKey("href") ?? ""
                    let keyclass = item2.objectForKey("class") ?? ""
                    self?.nextLink = origin
                    if keyclass == "active" {
//                         print(item2.content)
                        self?.currentPage = Int(item2.content) ?? 1
                        if (self?.currentPage  == 1){
                           self?.previousLink = url
                        }
                    }
                   
                }
               
            }
        }
        
         self?.collectionViewStory.reloadData()
        }
        else{
            let elements = doc.searchWithXPathQuery("//div[@class='books-list-wpapper']")
//             print("elements")
//            print(elements)
            for eleItem in elements {
                let e0 = eleItem as! TFHppleElement
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
//                     print("e.content")
//                     print(e.content)
                    for eleItem1 in e.children {
                        let e1 = eleItem1 as! TFHppleElement
//                        print("e1.content")
//                        print(e1.content)
                        for eleItem2 in e1.children {
                            let e2 = eleItem2 as! TFHppleElement
//                            print("e2.content")
//                            print(e2.content)
                            for eleItem3 in e2.children {
                                let e3 = eleItem3 as! TFHppleElement
                                
                                for eleItem4 in e3.children {
                                    let e4 = eleItem4 as! TFHppleElement
//                                    print("e4.content")
//                                    print(e4.content)
                                    if let href4 = e4.objectForKey("href") {
//                                        print("href4")
//                                        print(href4)
                                        for eleItem5 in e4.children {
                                            let e5 = eleItem5 as! TFHppleElement
                                            if let src = e5.objectForKey("src"){
 
                                                let itemStory = StoryInfoModel()
                                                 let urlSourceString :String = src.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                                                let urlString :String = href4.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                                                    itemStory.storyUrl = urlString
                                                    itemStory.storyImgUrl = urlSourceString
                                                if  let title = e5.objectForKey("title"){
                                                     itemStory.storyName = title
                                                    }
                                                    self?.arrStory?.append(itemStory)
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
        vc.arrType = self.arrFilterDTO()
        vc.block = {[weak self] (result)->() in
            let url = String(format: "%@%@",BaseUrl,result.storyUrl ?? "")
            self?.loadData(url,isRefresh: true)
            let pa = NSMutableDictionary()
            pa.setObject(result, forKey: "story")
            Utils.saveFilterParams(pa)
            let title = result.storyName ?? ""
            self?.fakeNavi.lblTitle.text =  title
            self?.collectionViewStory.scrollsToTop = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func arrTest()->[StoryInfoModel]{
         var result = [StoryInfoModel]()
        
        let itemNew = StoryInfoModel()
        itemNew.storyName = "Airport"
        itemNew.storyUrl = "/241269-airport.html"
        itemNew.storyImgUrl = "/uploads/truyen/Airport.jpg"
        result.append(itemNew)
        
        let itemNew2 = StoryInfoModel()
        itemNew2.storyName = "The Historian"
        itemNew2.storyUrl = "/241337-the-historian.html"
        itemNew2.storyImgUrl = "/uploads/truyen/The-Historian.jpg"
        result.append(itemNew2)
        
        let itemNew3 = StoryInfoModel()
        itemNew3.storyName = "Teenage Mermaid"
        itemNew3.storyUrl = "/241217-teenage-mermaid.html"
        itemNew3.storyImgUrl = "/uploads/truyen/Teenage-Mermaid.jpg"
        result.append(itemNew3)
        
        let itemNew4 = StoryInfoModel()
        itemNew4.storyName = "Our Lady of Darkness"
        itemNew4.storyUrl = "/241960-our-lady-of-darkness.html"
        itemNew4.storyImgUrl = "/uploads/truyen/Our-Lady-of-Darkness.jpg"
        result.append(itemNew4)
        
        let itemNew5 = StoryInfoModel()
        itemNew5.storyName = "Boy's Life"
        itemNew5.storyUrl = "/241659-boys-life.html"
        itemNew5.storyImgUrl = "/uploads/truyen/Boys-Life.jpg"
        result.append(itemNew5)
        
        let itemNew6 = StoryInfoModel()
        itemNew6.storyName = "Of Swine and Roses"
        itemNew6.storyUrl = "/241518-of-swine-and-roses.html"
        itemNew6.storyImgUrl = "/uploads/truyen/Of-Swine-and-Roses.jpg"
        result.append(itemNew6)
        
        let itemNew7 = StoryInfoModel()
        itemNew7.storyName = "Questing Beast"
        itemNew7.storyUrl = "/241519-questing-beast.html"
        itemNew7.storyImgUrl = "/uploads/truyen/Questing-Beast.jpg"
        result.append(itemNew7)
        
        return result
    }
    
    func arrFilterDTO()->[StoryInfoModel] {
        var result = [StoryInfoModel]()
        
        let itemNew = StoryInfoModel()
        itemNew.storyName = "NEW BOOKS"
        itemNew.storyUrl = "/"
        itemNew.storyImgUrl = "new"
        result.append(itemNew)
        
        let itemHot = StoryInfoModel()
        itemHot.storyName = "Nonfiction"
        itemHot.storyUrl = "/genre/nonfiction-16"
        itemHot.storyImgUrl = "hot"
        result.append(itemHot)
        
        let itemRomance = StoryInfoModel()
        itemRomance.storyName = "Love & Romance"
        itemRomance.storyUrl = "/genre/love-romance-1"
         itemRomance.storyImgUrl = "romanovel"
        result.append(itemRomance)
        
        let itemYAdult = StoryInfoModel()
        itemYAdult.storyName = "Children"
        itemYAdult.storyUrl = "/genre/children-10"
         itemYAdult.storyImgUrl = "young"
        result.append(itemYAdult)
        
        let itemAdventure = StoryInfoModel()
        itemAdventure.storyName = "Action & Adventure"
        itemAdventure.storyUrl = "/genre/action-adventure-9"
         itemAdventure.storyImgUrl = "adventure"
        result.append(itemAdventure)
        
        let itemFantasy = StoryInfoModel()
        itemFantasy.storyName = "Fantasy"
        itemFantasy.storyUrl = "/genre/fantasy-6"
         itemFantasy.storyImgUrl = "fantasy"
        result.append(itemFantasy)

        
        let itemHorror = StoryInfoModel()
        itemHorror.storyName = "Horror"
        itemHorror.storyUrl = "/genre/horror-7"
         itemHorror.storyImgUrl = "horror"
        result.append(itemHorror)
        
        let itemMystery = StoryInfoModel()
        itemMystery.storyName = "Mystery"
        itemMystery.storyUrl = "/genre/mystery-3"
         itemMystery.storyImgUrl = "mystery"
        result.append(itemMystery)
        
        let itemScience = StoryInfoModel()
        itemScience.storyName = "Science Fiction"
        itemScience.storyUrl = "/genre/science-fiction-5"
         itemScience.storyImgUrl = "science"
        result.append(itemScience)
        
        let itemWestern = StoryInfoModel()
        itemWestern.storyName = "Western"
        itemWestern.storyUrl = "/genre/western-2"
         itemWestern.storyImgUrl = "western"
        result.append(itemWestern)
        
        let itemChristian = StoryInfoModel()
        itemChristian.storyName = "Drama"
        itemChristian.storyUrl = "/genre/drama-11"
         itemChristian.storyImgUrl = "christian"
        result.append(itemChristian)
        
        let itemHistorical = StoryInfoModel()
        itemHistorical.storyName = "Historical"
        itemHistorical.storyUrl = "/genre/historical-fiction-8"
        itemHistorical.storyImgUrl = "historical"
        result.append(itemHistorical)
        
        let itemHumorous = StoryInfoModel()
        itemHumorous.storyName = "Comedy"
        itemHumorous.storyUrl = "/genre/comedy-12"
        itemHumorous.storyImgUrl = "humorous"
        result.append(itemHumorous)
        
        let itemThriller = StoryInfoModel()
        itemThriller.storyName = "Thriller"
        itemThriller.storyUrl = "/genre/thriller-4"
        itemThriller.storyImgUrl = "thriller"
        result.append(itemThriller)
        
        let itemPoetry = StoryInfoModel()
        itemPoetry.storyName = "Poetry"
        itemPoetry.storyUrl = "/genre/poetry-13"
        itemPoetry.storyImgUrl = "thriller"
        result.append(itemPoetry)
        
        
        let itemClassic = StoryInfoModel()
        itemClassic.storyName = "Classic Authors"
        itemClassic.storyUrl = "/genre/classic-authors-14"
        itemClassic.storyImgUrl = "thriller"
        result.append(itemClassic)
        
        let itemLiterature = StoryInfoModel()
        itemLiterature.storyName = "Literature"
        itemLiterature.storyUrl = "/genre/literature-15"
        itemLiterature.storyImgUrl = "thriller"
        result.append(itemLiterature)
      
        
        return result
    }
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
                 owner.loadData(owner.nextLink, isRefresh: false)
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
