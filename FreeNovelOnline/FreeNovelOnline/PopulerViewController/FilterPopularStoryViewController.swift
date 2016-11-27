//
//  FilterStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/11/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit




class FilterPopularStoryViewController: BaseViewController ,TagListViewDelegate {

 
   
    @IBOutlet weak var categoryListTag: TagListView!
 
    @IBOutlet weak var contraitHeightListTag: NSLayoutConstraint!
    
  
    
    
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
   
      
        
        contraitHeightListTag.constant = CGFloat(categoryListTag.rows) * (categoryListTag.tagViewHeight +   categoryListTag.marginY)
        
        
        self.updatePreviousSlection()
    }
    
    func updatePreviousSlection(){
        if self.param != nil {
            
            let cate = self.param!.valueForKey(keycategoryparam) as? String ?? ""
            var indexCount = 37
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
                indexCount -= 1
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
            
         
 
         
            
        }
    }
    
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        
            for tag in sender.tagViews {
                tag.selected = (tag == tagView)
                
            }
              
            categorySelectName = title
            for tag in sender.tagViews {
               if tag.selected == true {
                   arrParamCate[arrParamCate.count - 1  - (tag.numTag - 1)] = 1 //tag.numTag
                
               }else{
                  arrParamCate[arrParamCate.count - 1 - (tag.numTag - 1)] = 0
                }
            }
            
            self.category = ""
            for item  in arrParamCate {
                category = String(format:"%@%d",category,item)
                
            }
  
    }

}


extension FilterPopularStoryViewController {
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
        self.param?.setValue("", forKey: keywordparam)
        self.param?.setValue(categorySelectName, forKey: keycategorynameparam)
       
        if block != nil {
            block!(self.param!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}


