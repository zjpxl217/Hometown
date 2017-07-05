//
//  LogOnController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/10.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit
import SwiftHTTP
import ObjectMapper

class LogOnController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CommonHelp.SetBorderStyle(passwordText)
        CommonHelp.SetBorderStyle(mobileText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOn(_ sender: AnyObject) {
        do {
            
            if(checkParameter() == false) {return}
            
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Login/Index", parameters: ["mobile": self.mobileText.text!,"password": self.passwordText.text!])
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    let personnel =  Personnel(JSONString: response.text!)

                    //如果登陆成功，则跳转到首页
                    if(personnel?.PersonnelID! != "")
                    {
                        self.dismiss(animated: true, completion:nil)
                    }
                    else{
                        //用户名或密码错误
                        
                        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){
                            (action: UIAlertAction!) -> Void in
                            //print("you choose ok")
                        }
                        
                        let alert1 = UIAlertController(title: "登陆提示", message: "用户名或密码错误！",preferredStyle: UIAlertControllerStyle.alert)
                        alert1.addAction(okAction)

                        self.present(alert1, animated: true, completion: nil)
                    }
                    
                    
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func  checkParameter()->Bool
    {
        let name = self.mobileText.text!
        let password = self.passwordText.text!
        
        var  message=""
        if(name=="")
        {
            message="请输入用户名！"
        }else{
            if(password=="")
            {
                message="请输入密码！"
            }
        }
        
        
        if(message=="")
        {
            return true
        }else{
            
            
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){
                (action: UIAlertAction!) -> Void in
                
            }
            
            let alert1 = UIAlertController(title: "登陆提示", message: message,preferredStyle: UIAlertControllerStyle.alert)
            alert1.addAction(okAction)
            
            self.present(alert1, animated: true, completion: nil)
            
            return false
        }
        
    }

    

    @IBAction func register(_ sender: AnyObject) {
        
        let registerController = RegisterController()
        registerController.hidesBottomBarWhenPushed=true
        registerController.title="注册"
        
        
        self.present(registerController, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
