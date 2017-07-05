//
//  FeedController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/6.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit
import Foundation
import SwiftHTTP
import ObjectMapper

class FeedController: UITableViewController,UITextFieldDelegate {
    
    var feedList:Feeds?
    var replyViewDraw:CGFloat!
    
    let imagePicView = UIView()
    let imagePic = UIImageView()
    let nameLable = UILabel()
    let avatorImage = UIImageView()
    var selectItems: [Bool] = []
    
    //被回复人ID
    var replyToID:String?
    
    var commentView = pingLunFun()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView?.tableHeaderView = headerView()
        
        self.commentView.commentTextField.delegate = self
        commentView.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:30)
        commentView.isHidden = true
        //self.view.addSubview(self.commentView)
        
      
        appDelegate.window?.addSubview(self.commentView)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedController.handleTap)))
        
       
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        CommonHelp.GoToLogOn(self)
        CommonHelp.GetPersonnel()
        self.title="黑龙江.宁安市"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        GetFeedListByObjectID();


        NotificationCenter.default.addObserver(self, selector:#selector(FeedController.keyBoardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(FeedController.keyBoardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func viewDidLayoutSubviews() {
        
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(feedList==nil)
        {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return feedList!.feeds!.count
        
    }
    
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        selectItems.append(false)
        
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "FeedCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! FeedCell
        
        
        let userImagePathUrl = feedList?.feeds?[indexPath.item].PicturePath!
        let publishImageUrl=feedList?.feeds?[indexPath.item].ImgPathList!
        let content=feedList?.feeds?[indexPath.item].Content!
        let userName=feedList?.feeds?[indexPath.item].NikeName!
        let publishTime=feedList?.feeds?[indexPath.item].CreateDate!
        
        let commentList = feedList?.feeds?[indexPath.item].CommentList
        let favorList=feedList?.feeds?[indexPath.item].FavorList

        

        cell.feedID=(feedList?.feeds?[indexPath.item].FeedID)!
        cell.content.text=content
        cell.userName.text=userName
        cell.publishTime.text = CommonHelp.SetTimeFormat(publishTime!)
        
        cell.SetUserImageProperty(userImagePathUrl!)
        var remoteImage :[String] = []
        //remoteImage.append(publishImageUrl!)
        remoteImage = publishImageUrl!
        
        cell.SetContentProperty(content!,indexRow: indexPath,selectItem: selectItems[indexPath.row],remoteImage: remoteImage,favorList: favorList!,commentList: commentList!)
        
        //弹出图片
        cell.displayView.tapedImageV = {[unowned self] index in
            cell.pbVC.show(inVC: self,index: index)
        }
        
        cell.heightZhi = { cellflag in
            self.selectItems[indexPath.row] = cellflag
            self.tableView?.reloadData()
        }
        
        cell.likechange = { cellflag in
            //self.likeItems[indexPath.row] = cellflag
            //self.tableView?.reloadData()
            self.sendFavor(parentFeedID: cell.feedID)

        }

        
        //评论
        cell.commentchange = { _ in
            self.replyViewDraw = cell.convert(cell.bounds,to:self.view.window).origin.y + cell.frame.size.height
            self.commentView.commentTextField.becomeFirstResponder()
            self.commentView.sendBtn.addTarget(self, action: #selector(FeedController.sendComment), for:.touchUpInside)
            self.commentView.sendBtn.tag = indexPath.row
            self.commentView.commentTextField.placeholder = "评论"
         }
        
        //回复
        cell.answerchange = { replyToID  in
            self.replyViewDraw = cell.convert(cell.bounds,to:self.view.window).origin.y + cell.frame.size.height
            self.commentView.commentTextField.becomeFirstResponder()
            self.commentView.sendBtn.addTarget(self, action: #selector(FeedController.sendAnswer), for:.touchUpInside)
            self.commentView.sendBtn.tag = indexPath.row
            
            self.replyToID = replyToID
            
            self.commentView.commentTextField.placeholder = "回复"
            
        }
        
        
        return cell
    }
    
    //动态设置行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h_content = CellHelper.cellHeightByData((feedList?.feeds?[indexPath.item].Content!)!)
        
        let imageCount = feedList?.feeds?[indexPath.item].ImgPathList?.count
        let h_image = CellHelper.cellHeightByImage(imageCount!)
        
//        let commentCount = feedList?.feeds?[indexPath.item].CommentList?.count
//        let h_comment = CellHelper.cellHeightByCommentNum(commentCount!)
        
        var h_comment:CGFloat=0.0
        for item in (feedList?.feeds?[indexPath.item].CommentList)!{
            
             //h_comment+=CellHelper.cellHeightByData(item.Content!)
            
            
            var  commnetContent:String = ""
            if(item.ReplyToName != "")
            {
                commnetContent = item.PersonnelName! + " 回复 " + item.ReplyToName! + ":"+item.Content!
           
            }else{
                commnetContent = item.PersonnelName! + ":" + item.Content!
            
            }
            
             h_comment+=CellHelper.cellHeightByData(commnetContent)
            
            
        }
       

        let likeCount=feedList?.feeds?[indexPath.item].FavorList?.count
        var h_like:CGFloat = 0.0

        if likeCount! > 0{
            h_like = 30
        }
        
        return h_content + h_image + 50  + h_like + h_comment
    }
    
  
    func GetFeedListByObjectID()
    {
        
        do {
            
            let createDate=CommonHelp.GetCurrentTime()
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Feed/GetFeedListByObjectID", parameters: ["objectID":"9","createDate":createDate,"areaType":"Province"])
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                
                
                   
                    self.feedList = Feeds(JSONString: response.text!)
                    
                   
                    self.tableView.reloadData()
                    
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    //发布老家信息
    @IBAction func publishFeed(_ sender: AnyObject) {
        
        let publishFeedController = PublishFeedController()
        publishFeedController.title=""
        
        //self.presentViewController(publishFeedController, animated: false, completion: {})
        
        self.navigationController!.pushViewController(publishFeedController, animated:true)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.commentView.commentTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    

    func keyBoardWillShow(note:NSNotification)
    {
        
        let userInfo  = note.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
       
        
        let deltaY = keyBoardBounds.size.height
        let commentY = self.view.frame.height - deltaY
       
        var frame = self.commentView.frame
        
        let animations:(() -> Void) = {
            self.commentView.isHidden = false
            self.commentView.frame.origin.y = commentY - 30
           
            frame.origin.y = commentY
            var point:CGPoint = self.tableView!.contentOffset
            
            
            point.y -= (frame.origin.y - self.replyViewDraw)
            point.y += self.commentView.frame.size.height

            self.tableView!.contentOffset = point
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    func keyBoardWillHide(note:NSNotification)
    {
        
        let userInfo  = note.userInfo! as NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.commentView.isHidden = true
            self.commentView.transform = CGAffineTransform.identity
            self.tableView!.frame.origin.y = 0
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }

    
   
    
    func headerView() ->UIView{
        
        imagePicView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 225)
        imagePic.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
        imagePic.image = UIImage(named: "laojia")
        imagePicView.addSubview(imagePic)
        imagePic.clipsToBounds = true
        self.nameLable.frame = CGRect(x: 0, y: 170, width: 60, height: 18)
        self.nameLable.frame.origin.x = self.view.bounds.width - 140
        self.nameLable.text = "邹青鸣"
        self.nameLable.font = UIFont.systemFont(ofSize: 16)
        self.nameLable.textColor = UIColor.white
        self.avatorImage.frame = CGRect(x: 0, y: 150, width: 70, height: 70)
        self.avatorImage.frame.origin.x = self.view.bounds.width - 80
        self.avatorImage.image = UIImage(named: "qingming")
        self.avatorImage.layer.borderWidth = 2
        self.avatorImage.layer.borderColor = UIColor.white.cgColor
        let view:UIView = UIView(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 26))
        view.backgroundColor = UIColor.white
        imagePicView.addSubview(nameLable)
        imagePicView.addSubview(view)
        imagePicView.addSubview(avatorImage)
        return imagePicView
    }
    
    //点赞（取消赞）
    func sendFavor(parentFeedID:String){
        
       
        do {
            
            //api-Feed-AjaxAddFeedBack_content_type_parentFeeedID
            let opt = try HTTP.POST("http://hometown.lookchallenge.com/api/Feed/AjaxAddFeedBack?content=''&type=1&parentFeedID="+parentFeedID+"&replyTo=", parameters: nil)
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                     self.GetFeedListByObjectID();
                    
                    } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

        
    }
    
   
    func sendComment(sender:UIButton){
        
        let content = commentView.commentTextField.text!
        let parentFeedID = (feedList?.feeds?[sender.tag].FeedID)!
        do {
            
            //api-Feed-AjaxAddFeedBack_content_type_parentFeeedID
            let opt = try HTTP.POST("http://hometown.lookchallenge.com/api/Feed/AjaxAddFeedBack?content="+content+"&type=2&parentFeedID="+parentFeedID+"&replyTo=", parameters: nil)
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                      self.GetFeedListByObjectID();
                    
                    } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    //发送回复
    func sendAnswer(sender:UIButton){
        
        let content = commentView.commentTextField.text!
        let parentFeedID = (feedList?.feeds?[sender.tag].FeedID)!
        let replayTo = self.replyToID!

        let paramenter="content="+content+"&type=2&parentFeedID="+parentFeedID+"&replyTo="+replayTo
        
        do {
            
            //api-Feed-AjaxAddFeedBack_content_type_parentFeeedID
            let opt = try HTTP.POST("http://hometown.lookchallenge.com/api/Feed/AjaxAddFeedBack?"+paramenter, parameters: nil)
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                    self.GetFeedListByObjectID();
                    
                    } as @convention(block) () -> Void)
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
