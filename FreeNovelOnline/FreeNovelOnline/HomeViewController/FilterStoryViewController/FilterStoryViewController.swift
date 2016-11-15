//
//  FilterStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/11/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit

let kTagTypeListTag = 1
let kTagStatusListTag = 2
let kTagCategoryListTag = 3
let kTagSortOrderTag = 4

let keywordparam = "keywordparam"
let keycategoryparam = "keycategoryparam"
let keytypeparam = "keytypeparam"
let keystatusparam = "keystatusparam"
let keyorderparam = "keyorderparam"
let keycategorynameparam = "keycategorynameparam"


class FilterStoryViewController: BaseViewController ,TagListViewDelegate {

 
    @IBOutlet weak var typeListTag: TagListView!
    @IBOutlet weak var statusListTag: TagListView!
    @IBOutlet weak var categoryListTag: TagListView!
    @IBOutlet weak var sortOrder: TagListView!
    
    @IBOutlet weak var contraitType: NSLayoutConstraint!
    
    @IBOutlet weak var contraitStatus: NSLayoutConstraint!
    
    @IBOutlet weak var contraitCategory: NSLayoutConstraint!
    
    @IBOutlet weak var contraitSort: NSLayoutConstraint!
    
    
     var arrParamCate = [0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0  ,0,0,0   ,0,0,0  ,0,0,0 ,0]
     var block:((NSMutableDictionary)->())?
     var category:String = ""
     var status:String = ""
     var order:String = ""
     var rd:String = ""
     var categorySelectName:String = ""
 
    var param:NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        
     self.setupLayout()
        
      
    
    }

 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupLayout(){
        categoryListTag.alignment = .Center
        
        categoryListTag.addTag("Action").numTag = 37
        categoryListTag.addTag("Adventure").numTag = 36
        categoryListTag.addTag("Comedy").numTag = 35
        categoryListTag.addTag("Demons").numTag = 34
        categoryListTag.addTag("Drama").numTag =  33
        categoryListTag.addTag("Ecchi").numTag =  32
        categoryListTag.addTag("Fantasy").numTag = 31
        
        categoryListTag.addTag("Gender Bender").numTag = 30
        categoryListTag.addTag("Harem").numTag = 29
        categoryListTag.addTag("Historical").numTag = 28
        categoryListTag.addTag("Horror").numTag = 27
        categoryListTag.addTag("Josei").numTag =  26
        categoryListTag.addTag("Magic").numTag = 25
        categoryListTag.addTag("Martial Arts").numTag = 24
        categoryListTag.addTag("Mature").numTag = 23
        categoryListTag.addTag("Mecha").numTag = 22
        categoryListTag.addTag("Molitary").numTag = 21
        categoryListTag.addTag("Mystery").numTag = 20
        categoryListTag.addTag("One Shot").numTag = 19
        categoryListTag.addTag("Psychological").numTag = 18
        categoryListTag.addTag("Romance").numTag = 17
        categoryListTag.addTag("School Life").numTag = 16
        categoryListTag.addTag("Sci-Fi").numTag = 15
        categoryListTag.addTag("Seinen").numTag = 14
        categoryListTag.addTag("Shoujo").numTag = 13
        categoryListTag.addTag("Shoujoai").numTag = 12
        categoryListTag.addTag("Shounen").numTag = 11
        categoryListTag.addTag("Shounenai").numTag = 10
        categoryListTag.addTag("Slice of Life").numTag = 9
        categoryListTag.addTag("Smut").numTag = 8
        categoryListTag.addTag("Sports").numTag = 7
        categoryListTag.addTag("Super Power").numTag = 6
        categoryListTag.addTag("Supernatural").numTag = 5
        categoryListTag.addTag("Tragedy").numTag = 4
        categoryListTag.addTag("Vampire").numTag = 3
        categoryListTag.addTag("Yaoi").numTag = 2
        categoryListTag.addTag("Yuri").numTag = 1
        
        categoryListTag.delegate = self
        
//        print("categoryListTag.rows")
//        print(categoryListTag.rows)
//        print("tagViewHeight")
//        print(categoryListTag.tagViewHeight)
        
        contraitCategory.constant = CGFloat(categoryListTag.rows) * (categoryListTag.tagViewHeight + categoryListTag.paddingY)
        
        typeListTag.alignment = .Center
        typeListTag.addTag("Both(Manga and Manhwa)").numTag =  0
        typeListTag.addTag("Manhwa(Reading Left to Right").numTag =  1
        typeListTag.addTag("Manga(Reading Right to Left").numTag =  2
        
        typeListTag.delegate = self
        
        print("typeListTag.rows")
        print(typeListTag.rows)
        print("typeListTag.tagViewHeight")
        print(typeListTag.tagViewHeight)
        
        contraitType.constant = CGFloat(typeListTag.rows) * (typeListTag.tagViewHeight + typeListTag.paddingY)
        
        statusListTag.alignment = .Center
        statusListTag.addTag("Both(Ongoing and Complete)").numTag =  0
        statusListTag.addTag("Ongoing").numTag =  1
        statusListTag.addTag("Complete").numTag =  2
        
        statusListTag.delegate = self
        
        contraitStatus.constant = CGFloat(statusListTag.rows) * (statusListTag.tagViewHeight + statusListTag.paddingY )
        
        sortOrder.alignment = .Center
        sortOrder.addTag("Similarity").numTag =  0
        sortOrder.addTag("Alphabetical").numTag =  1
        sortOrder.addTag("Popularity").numTag =  2
        
        sortOrder.delegate = self
        
        contraitSort.constant = CGFloat(sortOrder.rows) * (sortOrder.tagViewHeight + sortOrder.paddingY )
        
        
        categoryListTag.tag = kTagCategoryListTag
        sortOrder.tag = kTagSortOrderTag
        typeListTag.tag = kTagTypeListTag
        statusListTag.tag =  kTagStatusListTag
        
        
        self.updatePreviousSlection()
    }
    
    func updatePreviousSlection(){
        if self.param != nil {
            let rd = Int(self.param!.valueForKey(keytypeparam) as? String ?? "0")
            for tag in typeListTag.tagViews {
                tag.selected = (tag.numTag == rd)
                if tag.selected == true {
                    self.rd = "\( tag.numTag)"
                }
            }
            let cate = self.param!.valueForKey(keycategoryparam) as? String ?? "0"
            var indexCount = 1
            for item in cate.characters {
                if item == "1" {
                    for tag in categoryListTag.tagViews {
                        if tag.numTag == indexCount {
                            tag.selected = true
                        }
                        if tag.selected == true {
                            self.status = "\( tag.numTag)"
                              categorySelectName = tag.titleLabel?.text ?? ""
                        }
                    }

                }
                indexCount += 1
            }
            
          
            for tag in categoryListTag.tagViews {
                if tag.selected == true {
                    arrParamCate[tag.numTag - 1] = 1 //tag.numTag
                    
                }else{
                    arrParamCate[tag.numTag - 1] = 0
                }
            }
            
            self.category = ""
            for item  in arrParamCate {
                category = String(format:"%@%d",category,item)
                
            }
            
            let status = Int(self.param!.valueForKey(keystatusparam) as? String ?? "0")
            for tag in statusListTag.tagViews {
                tag.selected = (tag.numTag == status)
                if tag.selected == true {
                    self.status = "\( tag.numTag)"
                }
            }
 
            let order = Int(self.param!.valueForKey(keyorderparam) as? String ?? "0")
            for tag in sortOrder.tagViews {
                tag.selected = (tag.numTag == order)
                if tag.selected == true {
                    self.order = "\( tag.numTag)"
                }
            }
            
        }
    }
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        if sender.tag == kTagCategoryListTag {
            for tag in sender.tagViews {
                tag.selected = (tag == tagView)
                
            }
              
            categorySelectName = title
            for tag in sender.tagViews {
               if tag.selected == true {
                   arrParamCate[tag.numTag - 1] = 1 //tag.numTag
                
               }else{
                  arrParamCate[tag.numTag - 1] = 0
                }
            }
            
            self.category = ""
            for item  in arrParamCate {
                category = String(format:"%@%d",category,item)
                
            }
        }else{
            var stringValue = "0"
                for tag in sender.tagViews {
                        tag.selected = (tag == tagView)
                    if tag.selected == true {
                        stringValue = "\( tag.numTag)"
                    }
                    }
            
             if sender.tag == kTagStatusListTag {
                status = stringValue
             }else if sender.tag == kTagSortOrderTag{
                  order = stringValue
             }else if  sender.tag == kTagTypeListTag{
                 rd = stringValue
            }
        }
        print("Tag pressed: \(title), \(sender)")
    }

}


extension FilterStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
    }
    
   
     override func setUpNavigationBar() {
  
        navigationController?.navigationBar.setDefault(UINavigationBar.State.BackAndSave, vc: self)
       
        navigationItem.title = "Filter Story"
        self.navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnTap = false
        
        
}
    
    override func btnSaveTouch() {
        super.btnSaveTouch()
        self.param?.setValue(category, forKey: keycategoryparam)
        self.param?.setValue(rd, forKey: keytypeparam)
        self.param?.setValue(status, forKey: keystatusparam)
        self.param?.setValue(order, forKey: keyorderparam)
        self.param?.setValue("", forKey: keywordparam)
        self.param?.setValue(categorySelectName, forKey: keycategorynameparam)
       
        if block != nil {
            block!(self.param!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}


