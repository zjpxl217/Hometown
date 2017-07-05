//
//  CellHelper.swift
//  Hometown
//
//  Created by ZouJP on 17/5/20.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation
import SwiftHTTP
import JSONJoy
//import MBProgressHUD


open class CellHelper
{
    //计算文字高度
    class func cellHeightByData(_ data:String)->CGFloat{
        
        let content = data
        let height=content.stringHeightWith(14,width: UIScreen.main.bounds.width - 60 - 10)
        return  height
        
    }
    
    //计算文字宽度
    class func cellWidthByData(_ data:String)->CGFloat{
        
        let content = data
        let num = content.cellWidthByData(14,width: UIScreen.main.bounds.width - 60 - 10)
        return  num
        
    }
    
    //计算图片内容高度
    //根据图片个数计算高度
    class func cellHeightByImage(_ imageNum:Int)->CGFloat{
        
        let lines:CGFloat = (CGFloat(imageNum))/3
        var picHeight:CGFloat = 0
        switch lines{
        case 0...1:
            picHeight = 80
            break
        case 1...2:
            picHeight = 155
            break
        case 2...3:
            picHeight = 230
            break
        default:
            picHeight = 0
        }
        return picHeight
        
    }
    
    //计算评论个数与高度
    //规定每行评论高20
    class func cellHeightByCommentNum(_ Comment:Int)->CGFloat{
        return CGFloat(Comment * 20)
    }
    
}




