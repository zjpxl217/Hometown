//
//  CityController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/8.
//  Copyright © 2017年 ZouJP. All rights reserved.
//
import UIKit
import Foundation
import SwiftHTTP
import JSONJoy

class CityController: UITableViewController {
    
    let identify:String = "CityCell"

    
    internal var provinceID:Int!
     var cityList:Citys?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        GetCityListByProvinceID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(cityList==nil)
        {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityList!.citys!.count
    }
    
    func initTableView()
    {
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: identify)
        self.tableView.reloadData()
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        
        for subview in cell.contentView.subviews
        {
            subview.removeFromSuperview()
        }
        
        // Configure the cell...
        let cityNameLabel = UILabel(frame: CGRect(x: 40, y: 10, width: self.view.bounds.size.width, height: 30))
        //headerLabel.backgroundColor = UIColor.blackColor()
        //headerLabel.textColor = UIColor.whiteColor()
        cityNameLabel.numberOfLines = 0
        cityNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cityNameLabel.text=cityList?.citys?[indexPath.item].CityName!
        cell.contentView.addSubview(cityNameLabel)
        
        return cell
    }
    
    func GetCityListByProvinceID()
    {
        
        do {
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/City/GetAllCityByProvinceID", parameters: ["id": provinceID])
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    self.cityList =  Citys(JSONString: response.text!)
                    
                    //self.tableView.reloadData()
                    
                    self.initTableView()
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   
        do {
            
           
            let cityID = cityList?.citys?[indexPath.item].CityID!
            
            let url="http://hometown.lookchallenge.com/api/Account/SetHometown?provinceID="+provinceID.description+"&cityID="+(cityID?.description)!

            let opt = try HTTP.POST(url, parameters: nil)
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default){
                        (action: UIAlertAction!) -> Void in
                        //self.navigationController?.popViewController(animated: true)
                        self.tabBarController?.selectedIndex = 0
                    }
                    var messageT:String?
                    if((response.text!)=="0")
                    {
                        messageT="请重新选择老家！"
                    }
                    else{
                        messageT="已找到老家，回家吧！"
                    }
                    let alert1 = UIAlertController(title: "找老家", message: messageT,preferredStyle: UIAlertControllerStyle.alert)
                    alert1.addAction(okAction)
                    self.present(alert1, animated: true, completion: nil)
                })
            }
        
        } catch let error {
            print("got an error creating the request: \(error)")
        }

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
