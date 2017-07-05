//
//  MeController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/7.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit

class MeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChooseHomeTown(_ sender: AnyObject) {
        
        let chooseHometownController = ChooseHometownController()
        // 传递控件的title，在detailView里用于判断生成响应的控件
        chooseHometownController.title = "找老家-省份"
        // navigationController跳转到myOrderController
        self.navigationController!.pushViewController(chooseHometownController, animated:true)

    }

    @IBAction func SetHeadImage(_ sender: Any) {
        let setHeadImageController = SetHeadImageController()
        // 传递控件的title，在detailView里用于判断生成响应的控件
        setHeadImageController.title = "设置头像"
        // navigationController跳转到myOrderController
        self.navigationController!.pushViewController(setHeadImageController, animated:true)
        
    }
   
    @IBAction func UpdatePassword(_ sender: Any) {
        let updatePasswordController = UpdatePasswordController()
        // 传递控件的title，在detailView里用于判断生成响应的控件
        updatePasswordController.title = "修改密码"
        // navigationController跳转到myOrderController
        self.navigationController!.pushViewController(updatePasswordController, animated:true)

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
