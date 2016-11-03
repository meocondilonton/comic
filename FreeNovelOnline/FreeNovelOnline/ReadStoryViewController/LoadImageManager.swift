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
    
//    func updateData(url:String){
//        let image = UIImage(named: "placeholder")
//        let data = UIImageJPEGRepresentation(image!, 1.0)
////         self.webView.loadData(data!, MIMEType: "image/jpeg", textEncodingName: "utf-8", baseURL: NSURL())
//        
//        let urlString = String(format:"%@%@",BaseUrl,url)
////        self.loadChapterData(urlString)
//        
//    }
    
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
                            print("element")
                            print(link)
                            if self?.block != nil {
                                self?.block!(link as! String)
                            }
//                           self?.loadImg(link as! String)
//                             self?.webView.loadRequest(NSURLRequest(URL: NSURL(string: link as! String)!))
                        }
                    }
                }
                
                }
            }
            
        }
        
        
        
    }
    
//    func loadImg(url:String){
//        let param = NSMutableDictionary()
//        param.setValue(url , forKey: keyUrl)
//        self.wsImg =  LoadImgWebservice.shareInstance()
//        self.wsImg?.getData(param, isShowIndicator: false, block: { (result) in
////             self.webView.loadData(result!, MIMEType: "image/jpeg", textEncodingName: "utf-8", baseURL: NSURL())
//        })
//    }
    
}
