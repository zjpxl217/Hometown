//
//  PhotoBrowser+HUD.swift
//  Hometown
//
//  Created by ZouJP on 2017/6/4.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation

import UIKit


extension PhotoBrowser{
    
    
    /** 展示 */
    func showHUD(_ text: String,autoDismiss: Double){
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.hud.alpha = 1
        })
        
        hud.text = text
        
        self.view.addSubview(hud)
        hud.make_center(offsest: 0, width: 120, height: 44)
        
        if autoDismiss == -1 {return}
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(autoDismiss * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            self.dismissHUD()
        })
    }
    
    /** 消失 */
    func dismissHUD(){
        
        UIView.animate(withDuration: 0.25, animations: {[unowned self] () -> Void in
            
            self.hud.alpha = 0
            
            }, completion: { (compelte) -> Void in
                
                self.hud.text = ""
                
                self.hud.removeFromSuperview()
        })
    }
    
}
