//
//  Layout.swift
//  Hometown
//
//  Created by ZouJP on 17/5/21.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation
import UIKit

extension PhotoBrowser{
    
    
    class Layout: UICollectionViewFlowLayout {
        
        override init(){
            
            super.init()
            
            /**  配置  */
            layoutSetting()
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
        
        /**  配置  */
        func layoutSetting(){
            
            let size = UIScreen.main.bounds.size
            self.itemSize = size.sizeWithExtraWidth
            
            self.minimumInteritemSpacing = 0
            self.minimumLineSpacing = 0
            self.sectionInset = UIEdgeInsets.zero
            self.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
        
    }
    
    
    
}
