//
//  PhotoBrowser+Indicator.swift
//  Hometown
//
//  Created by ZouJP on 17/5/21.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation
import UIKit

extension PhotoBrowser{
    
    /** pagecontrol准备 */
    func pagecontrolPrepare(){
        
        if !hideMsgForZoomAndDismissWithSingleTap {return}
        
        view.addSubview(pagecontrol)
        pagecontrol.make_bottomInsets_bottomHeight(left: 0, bottom: 0, right: 0, bottomHeight: 37)
        pagecontrol.numberOfPages = photoModels.count
        pagecontrol.isEnabled = false
    }
    
    /** pageControl页面变动 */
    func pageControlPageChanged(_ page: Int){
        
        if page<0 || page>=photoModels.count {return}
        
        if showType == PhotoBrowser.ShowType.zoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap{
            
            pagecontrol.currentPage = page
        }
    }
}

