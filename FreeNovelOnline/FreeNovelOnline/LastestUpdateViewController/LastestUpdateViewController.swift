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
  var arrStory:[StoryFullInfoModel]? = [StoryFullInfoModel]()
    
   
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tbView.tableFooterView = UIView()
        self.setupLoadMoreAndPullRefresh()
     
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
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
                                print(e.attributes["class"])
                    
                    for eleItem in e.children {
                        let e1 =  eleItem as! TFHppleElement
                    if e1.attributes["class"]?.isEqualToString("chapter") == true   {
                                              print("e.content")
                                              print(e1.content)
                        let itemStory = StoryInfoModel()
                        for eleItem1 in e1.children {
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
                        }
//                        self?.arrStory?.append(itemStory)
                    }
                }
                
            }
            
            
            self?.tbView.reloadData()
        }
    }
    
    func setupLoadMoreAndPullRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
            
            })
        header.lastUpdatedTimeLabel!.hidden = true
        header.setTitle("Release To Refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Refreshing Data...", forState: MJRefreshState.Refreshing)
        header.setTitle("Pull To Refresh", forState: MJRefreshState.Idle)
        self.tbView.mj_header = header
    
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] () -> Void in
 
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
         let url = String(format: "%@/latest/",BaseUrl  )
        self.loadData(url, isRefresh: true)
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Empty, vc: self)
        
        navigationItem.title = "Latest Releases"
        
    }
}

extension LastestUpdateViewController :UITableViewDelegate , UITableViewDataSource {
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
            
            vc.storyFullInfo = StoryFullInfoModel()
            vc.storyFullInfo.storyImgUrl = storyInfo.storyImgUrl
            vc.storyFullInfo.storyName = storyInfo.storyName
            vc.storyFullInfo.storyUrl = storyInfo.storyUrl
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
