//
//  ChooseHometownController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/7.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit
import Foundation
import SwiftHTTP
import JSONJoy

class ChooseHometownController: UITableViewController {
    
    var provinceList:Provinces?
    
    let identify:String = "ProvinceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        GetProvinceList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(provinceList==nil)
        {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return provinceList!.provinces!.count
    }

    
    func initTableView()
    {
        
        //创建表视图
        //self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.Plain)
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: identify)
        
        
        //self.view.addSubview(self.tableView!)
        
        self.tableView.reloadData()
        
     
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        
        for subview in cell.contentView.subviews
        {
            subview.removeFromSuperview()
        }

        // Configure the cell...
        
        
        let provinceNameLabel = UILabel(frame: CGRect(x: 40, y: 10, width: self.view.bounds.size.width, height: 30))
        //headerLabel.backgroundColor = UIColor.blackColor()
        //headerLabel.textColor = UIColor.whiteColor()
        provinceNameLabel.numberOfLines = 0
        provinceNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let provinceName=provinceList?.provinces?[indexPath.item].ProvinceName!
        provinceNameLabel.text=provinceName
        
        showProvinceImage(cell,provinceName: translateProvinceName(provinceName!))
        
        cell.contentView.addSubview(provinceNameLabel)
        
       
        
        return cell
    }
    
    func showProvinceImage(_ cell:UITableViewCell,provinceName:String)
    {
        //let imageView=UIImageView(image:UIImage(named:"Image-1"))
        let imageView=UIImageView()
        imageView.image = UIImage(named:provinceName)
        imageView.frame=CGRect(x: 2,y: 6,width: 32,height: 32)
        
        cell.contentView.addSubview(imageView)
    }
    
    func translateProvinceName(_ provinceName:String)->String
    {
        var pinyinName=""
        
        switch(provinceName)
        {
        case "北京市":
            pinyinName = "beijing"
                break
        case "天津市":
            pinyinName = "tianjing"
            break
        case "上海市":
            pinyinName = "shanghai"
            break
        case "重庆市":
            pinyinName = "chongqing"
            break
        case "河北省":
            pinyinName = "hebei_shijiazhuang"
            break
        case "山西省":
            pinyinName = "shanxi_taiyuan"
            break
        case "辽宁省":
            pinyinName = "liaoning_shenyang"
            break
        case "吉林省":
            pinyinName = "jilin_changcun"
            break
        case "黑龙江省":
            pinyinName = "heilongjiang_haerbin"
            break
        case "江苏省":
            pinyinName = "jiangsu_nanjing"
            break
        case "浙江省":
            pinyinName = "zhejiang_hangzhou"
            break
        case "安徽省":
            pinyinName = "anhui"
            break
        case "福建省":
            pinyinName = "fujian_wuyishan"
            break
        case "江西省":
            pinyinName = "jiangxi"
            break
        case "山东省":
            pinyinName = "shandong"
            break
        case "河南省":
            pinyinName = "henan"
            break
        case "湖北省":
            pinyinName = "hubei_wudongshan"
            break
        case "湖南省":
            pinyinName = "hunan_zhangjiajie"
            break
        case "广东省":
            pinyinName = "guandong"
            break
        case "海南省":
            pinyinName = "hainan"
            break
        case "四川省":
            pinyinName = "sichuan"
            break
        case "贵州省":
            pinyinName = "guizhou"
            break
        case "云南省":
            pinyinName = "yunnan"
            break
        case "陕西省":
            pinyinName = "shanxi"
            break
        case "甘肃省":
            pinyinName = "gansu"
            break
        case "青海省":
            pinyinName = "qinghai"
            break
        case "台湾省":
            pinyinName = "taiwan"
            break
        case "广西壮族自治区":
            pinyinName = "guangxi"
            break
        case "内蒙古自治区":
            pinyinName = "neimenggu"
            break
        case "西藏自治区":
            pinyinName = "xizang"
            break
        case "宁夏回族自治区":
            pinyinName = "ningxia"
            break
        case "新疆维吾尔自治区":
            pinyinName = "xinjiang"
            break
        case "香港特别行政区":
            pinyinName = "xianggang"
            break
        case "澳门特别行政区":
            pinyinName = "aomen"
            break
        default :
                pinyinName=""
                break
        }
        
        return pinyinName
    }
    
    
    func GetProvinceList()
    {
        
        do {
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Province/GetAllProvinceList", parameters: nil)
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
            
                    self.provinceList =  Provinces(JSONString:response.text!)
                    //self.tableView.reloadData()
                    
                    self.initTableView()
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true);
        //获取点击的行索引
        let cityController = CityController()
        cityController.hidesBottomBarWhenPushed=true
        // 传递控件的title，在detailView里用于判断生成响应的控件
        cityController.title="城市"
        cityController.provinceID = provinceList?.provinces?[indexPath.item].ProvinceID!
      
        // navigationController跳转到detailViewController
        
        //self.presentViewController(detailViewController, animated: true, completion: nil)
        self.navigationController!.pushViewController(cityController, animated:true)

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
