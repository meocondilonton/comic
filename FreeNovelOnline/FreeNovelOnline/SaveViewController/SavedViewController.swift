//
//  SavedViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 8/29/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit
import MJRefresh
import GoogleMobileAds


class SavedViewController: BaseViewController {
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var btnGotoBook: UIButton!
    
    
     var arrStory:[StoryFullInfoModel]? = [StoryFullInfoModel]()
     var request:GADRequest!
     var numAd:Int = 0
    var numSelect:Int = 0
    
    @IBAction func btnGoToBookTouch(sender: AnyObject) {
        appdelegate.tabbar.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            self.setupLoadMoreAndPullRefresh()

        self.tbView.tableFooterView = UIView()
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    
    
    func getDefaultData(){
        self.arrStory?.removeAll()
        self.arrStory = DatabaseHelper.shareInstall().getAllStoryFullInfoSaved()
        if self.arrStory?.count <= 0 {
            self.vEmpty.hidden = false
        }else{
            self.vEmpty.hidden = true
        }

        self.tbView.mj_header.endRefreshing()
        self.tbView.reloadData()

    }
    
}


extension SavedViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         self.getDefaultData()
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
      
            navigationController?.navigationBar.setDefault(UINavigationBar.State.Empty, vc: self)
            navigationItem.title = "Bookmark"
      
        
        
    }
    
    override func btnDeleteTouch() {
        super.btnDeleteTouch()
        for item in self.arrStory! {
            if item.isSelect == true {
                DatabaseHelper.shareInstall().removeStorySaved(item)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
  
}

extension SavedViewController:  UITableViewDelegate,UITableViewDataSource  {
    override func scrollToTop() {
        super.scrollToTop()
        self.tbView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func setupLoadMoreAndPullRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
                        self?.getDefaultData()
            })
        header.lastUpdatedTimeLabel!.hidden = true
        header.setTitle("Release To Refresh", forState: MJRefreshState.Pulling)
        header.setTitle("Refreshing Data...", forState: MJRefreshState.Refreshing)
        header.setTitle("Pull To Refresh", forState: MJRefreshState.Idle)
        self.tbView.mj_header = header
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.arrStory?.count ?? 0
        return count
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
           return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryTableViewCell4", forIndexPath: indexPath) as! StoryTableViewCell4
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
