//
//  RecentViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 8/29/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import MJRefresh


class LastestUpdateViewController: BaseViewController {
  var arrStory:[StoryInfoModel]? = [StoryInfoModel]()
    var nextPage:String?
   
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tbView.tableFooterView = UIView()
        self.setupLoadMoreAndPullRefresh()
        
        let url = String(format: "%@/latest/",BaseUrl  )
        self.loadData(url, isRefresh: true)
     
    }
    
    @IBAction func btnGoToBookTouch(sender: AnyObject) {
        appdelegate.tabbar.selectedIndex = 0
    }
    
    
    func loadData(url:String , isRefresh:Bool )  {
        
        
        if self.tbView.mj_header.isRefreshing() == true {
            self.tbView.mj_header.endRefreshing()
        }
        if self.tbView.mj_footer.isRefreshing() == true {
            self.tbView.mj_footer.endRefreshing()
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
            
            let elements = doc.searchWithXPathQuery("//tr[@class='c2']")
//             print(elements)
            for eleItem in elements {
                let e0 = eleItem as! TFHppleElement
//                print("e0.raw")
//                 print(e0.raw)
                 let itemStory = StoryInfoModel()
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
//                                print(e.attributes["class"])
                    
                    for eleItem in e.children {
                      
                        let e1 =  eleItem as! TFHppleElement
                      
                    if e1.attributes["class"]?.isEqualToString("chapter") == true   {
                            itemStory.storyName = e1.content
                           self?.arrStory?.append(itemStory)
                        if let href = e1.objectForKey("href") {
                            itemStory.storyUrl = href
                        }

                    }else if ( e1.attributes["class"]?.isEqualToString("chaptersrec") == true) {
                        if  itemStory.storyRecentUpdate != nil {
                            
                            itemStory.storyRecentUpdate = String(format: "%@\n%@", itemStory.storyRecentUpdate ?? "" ,e1.content)
                        }else{
                              itemStory.storyRecentUpdate =  e1.content
                        }
                        
                        }
                        
                        
                }
                     if e.attributes["class"]?.isEqualToString("c1") == true   {
                        itemStory.storyDateUpdate = e.content
//                         print( itemStory.storyDateUpdate)
                    }
                
            }
            }
            
            let elementsPage = doc.searchWithXPathQuery("//div[@id='sp']")
            var arrPage = [String]()
            for eleItem in elementsPage {
                let e0 = eleItem as! TFHppleElement
                //                print("e0.raw")
                //                 print(e0.raw)
               
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
//                    print(e.attributes["class"])
                     if let href = e.objectForKey("href") {
//                           print("href")
//                           print(href)
                        arrPage.append(href)
                    }
                    
                    
                }
            }
            if arrPage.count > 1 {
               self?.nextPage =  arrPage[arrPage.count - 2]
//                print(" self?.nextPage")
//                print( self?.nextPage)
            }
            self?.tbView.reloadData()
        }
    }
    
    func setupLoadMoreAndPullRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
            let url = String(format: "%@/latest",BaseUrl   )
            self?.loadData(url, isRefresh: true)
            })
        header.lastUpdatedTimeLabel!.hidden = true
        header.setTitle("Release To Refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Refreshing Data...", forState: MJRefreshState.Refreshing)
        header.setTitle("Pull To Refresh", forState: MJRefreshState.Idle)
        self.tbView.mj_header = header
    
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] () -> Void in
            let url = String(format: "%@%@",BaseUrl , self?.nextPage ?? "" )
            self?.loadData(url, isRefresh: false)
            })
        
        footer.setTitle("Loading Data...", forState: MJRefreshState.Refreshing)
        footer.setTitle("No More Data...", forState: MJRefreshState.NoMoreData)
        footer.setTitle(" ", forState: MJRefreshState.Idle)
        self.tbView.mj_footer = footer
        
    }
    
}

extension LastestUpdateViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Empty, vc: self)
        
        navigationItem.title = "Latest Releases"
        
    }
}

extension LastestUpdateViewController :UITableViewDelegate , UITableViewDataSource {
    override func scrollToTop() {
        super.scrollToTop()
        
        self.tbView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrStory?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryTableViewCell3", forIndexPath: indexPath) as! StoryTableViewCell3
        if indexPath.row < self.arrStory?.count {
            cell.uodateData(self.arrStory![indexPath.row])
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row <= self.arrStory?.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("DetailInfoStoryViewController") as! DetailInfoStoryViewController
            
            let storyInfo = self.arrStory![indexPath.item]
            vc.isFromLastRelease = true
            vc.storyFullInfo = StoryFullInfoModel()
            vc.storyFullInfo.storyImgUrl = storyInfo.storyImgUrl
            vc.storyFullInfo.storyName = storyInfo.storyName
            vc.storyFullInfo.storyUrl = storyInfo.storyUrl
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
