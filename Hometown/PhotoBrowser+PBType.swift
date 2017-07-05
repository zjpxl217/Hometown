//
//  PhotoBrowser+PBType.swift
//  Hometown
//
//  Created by ZouJP on 17/5/21.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation


extension PhotoBrowser{
    
    /**  展示样式  */
    enum ShowType{
        
        /**  push展示：网易新闻  */
        case push
        
        /**  modal展示：可能有需要  */
        case modal
        
        /**  frame放大模式：单击相册可关闭 */
        case zoomAndDismissWithSingleTap
        
        /**  frame放大模式：点击按钮可关闭 */
        case zoomAndDismissWithCancelBtnClick
    }
    
    
    /**  相册类型  */
    enum PhotoType{
        
        /**  本地相册  */
        case local
        
        /**  服务器相册  */
        case host
    }
    
}
