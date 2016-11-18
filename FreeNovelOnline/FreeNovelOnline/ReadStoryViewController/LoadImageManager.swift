//
//  ReadStoryCollectionViewCell.swift
//  FreeNovelOnline
//
//  Created by long nguyen on 10/26/16.
//  Copyright © 2016 long nguyen. All rights reserved.
//

import UIKit

class LoadImageManager: NSObject  {
    
 
    var ws:LoadImgWebservice?
    var wsImg:LoadImgWebservice?
    var block:(( String)->())?
    
 
    
    func loadImage(page:String , block:(String)->() )  {
        let param = NSMutableDictionary()
        self.block = block
        param.setValue(page , forKey: keyUrl)
       self.ws =  LoadImgWebservice.shareInstance()
        ws?.getData(param, isShowIndicator: false) {[weak self] (result) in
            
            let doc = TFHpple(HTMLData: result)
            
            //read top
            let elements = doc.searchWithXPathQuery("//div[@id='imgholder']")
           
            for eleItem in elements {
                let e = eleItem as! TFHppleElement
                for item in e.children {
                    if let e2 = item as? TFHppleElement {
                    for item2 in e2.children {
 
                        if let link = item2.objectForKey("src") {
 
                            if self?.block != nil {
                                self?.block!(link as! String)
                            }
 
                        }
                    }
                }
                
                }
            }
            
        }
        
        
        
    }
    
 
    
}
