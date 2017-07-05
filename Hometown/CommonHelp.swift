//
//  CommonHelp.swift
//  Hometown
//
//  Created by ZouJP on 17/5/2.
//  Copyright © 2017年 ZouJP. All rights reserved.
//


import Foundation
import SwiftHTTP
import JSONJoy
//import MBProgressHUD


open class CommonHelp
{
    static let selfBlueColor = UIColor(red: 132.0/255, green:  112.0/255, blue:  255.0/255, alpha: 1).cgColor;
   
    
    class func GetCurrentTime()->String
    {
        let date:Date = Date()
        
        // 创建时间戳
        let formatter:DateFormatter = DateFormatter()
        
        // 设置日期格式，以字符串表示的日期形式的格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 转换成指定的格式
        let createDate:String = formatter.string(from: date)
        
        return createDate;
    }
    
    class func SetTimeFormat( _ datetime:String)->String
    {
        
        var nsDatetime:NSString = datetime as NSString
        nsDatetime=nsDatetime.substring(to: 10) as NSString
        
        return nsDatetime as String;
    }
    
    class func  SetBorderStyle(_ widget:AnyObject)
    {
        widget.layer.borderColor = CommonHelp.selfBlueColor
        widget.layer.cornerRadius = 5;
        widget.layer.borderWidth = 0.5;
    }

    
    class func GoToLogOn(_ controller:UIViewController)
    {
        do {
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Login/IsLogin")
            opt.start { response in
                if let _ = response.error {
                    if(response.statusCode==401)
                    {
                        let logOnController = LogOnController()
                        logOnController.title="登陆"
                        controller.present(logOnController, animated: false, completion: {})
                    }
                    
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    class func GetPersonnel()
    {

        do {
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Account/Get")
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.currentPerson=Personnel(JSONString:response.text!)!
                    
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
    }

    
}
