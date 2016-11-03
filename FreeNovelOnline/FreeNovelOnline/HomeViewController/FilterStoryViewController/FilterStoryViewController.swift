//
//  FilterStoryViewController.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 9/11/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit

class FilterStoryViewController: BaseViewController {

 
    @IBOutlet weak var typeListTag: TagListView!
    @IBOutlet weak var statusListTag: TagListView!
    @IBOutlet weak var categoryListTag: TagListView!
    @IBOutlet weak var sortOrder: TagListView!
    
    @IBOutlet weak var contraitType: NSLayoutConstraint!
    
    @IBOutlet weak var contraitStatus: NSLayoutConstraint!
    
    @IBOutlet weak var contraitCategory: NSLayoutConstraint!
    
    @IBOutlet weak var contraitSort: NSLayoutConstraint!
    
    var arrType:[StoryInfoModel]!
    var block:((StoryInfoModel)->())?
   
    
//    @IBOutlet weak var cellType: FilterTableViewCell!
//    
//    @IBOutlet weak var cellStatus: FilterTableViewCell!
//    
//    @IBOutlet weak var cellCatalog: FilterTableViewCell!
//    
//    @IBOutlet weak var cellSortOrder: FilterTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        
     self.setupLayout()
        
      
    
    }

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupLayout(){
        categoryListTag.alignment = .Center
        
        categoryListTag.addTag("Action")
        categoryListTag.addTag("Adventure")
        categoryListTag.addTag("Comedy")
        categoryListTag.addTag("Demons")
        categoryListTag.addTag("Drama")
        categoryListTag.addTag("Ecchi")
        categoryListTag.addTag("Fantasy")
        categoryListTag.addTag("Gender Bender")
        categoryListTag.addTag("Harem")
        categoryListTag.addTag("Historical")
        categoryListTag.addTag("Horror")
        categoryListTag.addTag("Horror")
        categoryListTag.addTag("Josei")
        categoryListTag.addTag("Magic")
        categoryListTag.addTag("Martial Arts")
        categoryListTag.addTag("Mature")
        categoryListTag.addTag("Mecha")
        categoryListTag.addTag("Molitary")
        categoryListTag.addTag("Mystery")
        categoryListTag.addTag("One Shot")
        categoryListTag.addTag("Psychological")
        categoryListTag.addTag("Romance")
        categoryListTag.addTag("School Life")
        categoryListTag.addTag("Sci-Fi")
        categoryListTag.addTag("Seinen")
        categoryListTag.addTag("Shoujo")
        categoryListTag.addTag("Shoujoai")
        categoryListTag.addTag("Shounen")
        categoryListTag.addTag("Shounenai")
        categoryListTag.addTag("Slice of Life")
        categoryListTag.addTag("Smut")
        categoryListTag.addTag("Sports")
        categoryListTag.addTag("Super Power")
        categoryListTag.addTag("Supernatural")
        categoryListTag.addTag("Tragedy")
        categoryListTag.addTag("Vampire")
        categoryListTag.addTag("Yaoi")
        categoryListTag.addTag("Yuri")
        
        print("categoryListTag.rows")
        print(categoryListTag.rows)
        print("tagViewHeight")
        print(categoryListTag.tagViewHeight)
        
        contraitCategory.constant = CGFloat(categoryListTag.rows) * categoryListTag.tagViewHeight
        
        typeListTag.alignment = .Center
        typeListTag.addTag("Both(Manga and Manhwa)")
        typeListTag.addTag("Manhwa(Reading Left to Right")
        typeListTag.addTag("Manga(Reading Right to Left")
        
        print("typeListTag.rows")
        print(typeListTag.rows)
        print("typeListTag.tagViewHeight")
        print(typeListTag.tagViewHeight)
        
        contraitType.constant = CGFloat(typeListTag.rows) * typeListTag.tagViewHeight
        
        statusListTag.alignment = .Center
        statusListTag.addTag("Both(Ongoing and Complete)")
        statusListTag.addTag("Ongoing")
        statusListTag.addTag("Complete")
        
        contraitStatus.constant = CGFloat(statusListTag.rows) * statusListTag.tagViewHeight
        
        sortOrder.alignment = .Center
        sortOrder.addTag("Similarity")
        sortOrder.addTag("Alphabetical")
        sortOrder.addTag("Popularity")
        
        contraitSort.constant = CGFloat(sortOrder.rows) * sortOrder.tagViewHeight

    }

}


extension FilterStoryViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
    }
    
   
     override func setUpNavigationBar() {
  
        navigationController?.navigationBar.setDefault(UINavigationBar.State.Back, vc: self)
       
        navigationItem.title = "Filter Story"
        self.navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnTap = false
        
        
}

}


