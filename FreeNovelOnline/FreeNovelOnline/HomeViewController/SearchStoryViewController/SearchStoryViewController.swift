//
//  SearchStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/11/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit


class SearchStoryViewController: BaseViewController {

    @IBOutlet weak var vEmpty: UIView!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
      var arrStory:[StoryInfoModel]? = [StoryInfoModel]()
    var cancel:Bool = false
    var currentPage = 0
    var timer:NSTimer?
    var ws:LoadImgWebservice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tfSearch.becomeFirstResponder()
        self.setUpTextField()
        self.tbView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextField() {
        self.tfSearch.attributedPlaceholder = NSAttributedString(string:"Search by title",
                                                                      attributes:[NSForegroundColorAttributeName: textWhiteBlurColor])
    }
    

}

extension SearchStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
  
}

extension SearchStoryViewController {
    func searchAfterDelay(key:String){
        if timer != nil {
            timer?.invalidate()
        }
        let userInfor = ["value":key]
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(SearchStoryViewController.searchStory), userInfo: userInfor, repeats: false)
    }
    
    func searchStory(timer: NSTimer!){
        let info = timer.userInfo
        let key = info?.valueForKey("value") as? String ?? ""
        
        let rd = "0"
        let cate = "0000000000000000000000000000000000000"
        let status = "0"
        let order = "0"

        let param = NSMutableDictionary()
       let originalUrl = String(format:UrlSearch,key,rd ?? "",status ?? "",order ?? "",cate ?? "",self.currentPage)
        let urlString :String = originalUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        param.setValue(urlString, forKey: keyUrl)
        ws = LoadImgWebservice()
        ws?.getData(param, isShowIndicator: false) {[weak self] (result) in
            
            self?.arrStory?.removeAll(keepCapacity: false)
           
            let doc = TFHpple(HTMLData: result)
            
            
            let elements = doc.searchWithXPathQuery("//div[@class='mangaresultitem']")
//                         print("elements")
//                        print(elements)
            for eleItem in elements {
                let e0 = eleItem as! TFHppleElement
                for eleItem0 in e0.children {
                    let e = eleItem0 as! TFHppleElement
                    //            print(e.attributes["class"])
                    //                                print("e.raw")
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
                                                //                                                print("e5.content")
                                                //                                                 if e5.raw != nil {
                                                //                                                print(e5.raw)
                                                //                                                }
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
            
            self?.tbView.reloadData()
        }
    }
   
    
    
    
}


extension SearchStoryViewController : UITextFieldDelegate  {
    
    @IBAction func btnCancelTouch(sender: AnyObject) {
        self.cancel = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.tfSearch.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        var stringSearch:NSString = textField.text!
        stringSearch = stringSearch.stringByReplacingCharactersInRange(range, withString: string)
        
        if stringSearch != "" && cancel == false{
            self.searchAfterDelay(textField.text ?? "")
        }
        return true
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let search = textField.text ?? ""
        if search != "" && cancel == false{
            self.searchAfterDelay(textField.text ?? "")
        }
    }
    
}

extension SearchStoryViewController :UITableViewDelegate , UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrStory?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryTableViewCell1", forIndexPath: indexPath) as! StoryTableViewCell1
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
