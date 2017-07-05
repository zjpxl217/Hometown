//
//  DisplayView.swift
//  Hometown
//
//  Created by ZouJP on 17/5/21.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class DisplayView: UIView {
    
    
    var tapedImageV: ((_ index: Int)->())?
    //拍照
    var takeImage:((_ index: Int)->())?
    
    var  takeImageButton:UIImageView =  UIImageView();
}


extension DisplayView{
    
   
    
    /** 准备 */
    func imgsPrepare(_ imgs: [String], isLocal: Bool){
        
        for i in 0 ..< imgs.count{
            let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imgV.backgroundColor = UIColor.lightGray
            imgV.isUserInteractionEnabled = true
            imgV.contentMode = UIViewContentMode.scaleAspectFill
            imgV.clipsToBounds = true
            
            imgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DisplayView.tapAction)))
            
            
            imgV.tag = i
            if isLocal {
                imgV.image = UIImage(named: imgs[i])
            }else{
                imgV.hnk_setImageFromURL(URL(string: imgs[i])!)
            }
            self.addSubview(imgV)
        }
    }
    
    /** 展示拍摄的图片 */
    func showImgs(_ imgs: [UIImage]){
        
        for i in 0 ..< imgs.count{
            let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imgV.backgroundColor = UIColor.lightGray
            imgV.isUserInteractionEnabled = true
            imgV.contentMode = UIViewContentMode.scaleAspectFill
            imgV.clipsToBounds = true
            
            imgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DisplayView.tapAction)))
            
            
            imgV.tag = i
            imgV.image =  imgs[i]
            
            self.addSubview(imgV)
            
        }
        
        self.takeImageButton.removeFromSuperview()
        self.addSubview(self.takeImageButton)
    }
    
    /** 添加拍摄图片按钮 */
    func addTakeImgsButton(){
        
        
            self.takeImageButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            self.takeImageButton.backgroundColor = UIColor.lightGray
            self.takeImageButton.isUserInteractionEnabled = true
            self.takeImageButton.contentMode = UIViewContentMode.scaleAspectFill
            self.takeImageButton.clipsToBounds = true
            
            self.takeImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DisplayView.imageAction)))
            self.takeImageButton.image =  UIImage(named: "a4h")
            self.addSubview(self.takeImageButton)
        
       
    }

    
    func tapAction(_ tap: UITapGestureRecognizer){
        tapedImageV?(tap.view!.tag)
    }
    
    func imageAction(_ tap: UITapGestureRecognizer){
         takeImage?(tap.view!.tag)
    }
    
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let totalRow = 3
        let totalWidth = self.bounds.size.width
        
        let margin: CGFloat = 5
        let itemWH = (totalWidth - margin * CGFloat(totalRow + 1)) / CGFloat(totalRow)
        
        /** 数组遍历 */
        var i=0
        
        for view in self.subviews{
            
            let row = i / totalRow
            let col = i % totalRow
            
            let x = (CGFloat(col) + 1) * margin + CGFloat(col) * itemWH
            let y = (CGFloat(row) + 1) * margin + CGFloat(row) * itemWH
            let frame = CGRect(x: x, y: y, width: itemWH, height: itemWH)
            view.frame = frame
            i += 1
        }
    }
}
