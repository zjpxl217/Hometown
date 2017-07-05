//
//  PublishFeedController.swift
//  Hometown
//
//  Created by ZouJP on 17/5/13.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit
import Foundation
import SwiftHTTP
import JSONJoy

class PublishFeedController: UIViewController,UINavigationControllerDelegate
,UIImagePickerControllerDelegate,UITextViewDelegate {

    var imagePicker: UIImagePickerController!
    var imageView:UIImageView!
    var imagePath:String = ""

    var displayView = DisplayView()
    
    
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
  
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
        
        let item=UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PublishFeedController.publishFeed))
        self.navigationItem.rightBarButtonItem=item
      
       // self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        
       self.textView.delegate = self
        
       displayView.frame =  CGRect(x: 16, y: 144, width: 192, height: 64)
       displayView.addTakeImgsButton()
       self.view.addSubview(displayView)
       //弹出图片
       displayView.takeImage = {[unowned self] index in
        
            self.takeImage()
       }
        

    }
    
    //控制 placeholderLabel 显示和隐藏
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       
        self.placeholderLabel.isHidden = true // 隐藏
        return true
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false  // 显示
        }
        else{
            self.placeholderLabel.isHidden = true  // 隐藏
        }
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func publishFeed()
    {
        
        do {
            
            //api-Feed-PublishFeed_content_imagePath_parentFeeedID
        
            let content = textView.text
            let imagePathLength = self.imagePath.lengthOfBytes(using:  String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            if(imagePathLength>0)
            {
                let index = self.imagePath.index(self.imagePath.startIndex, offsetBy: imagePathLength-1)
                self.imagePath = self.imagePath.substring(to: index)
            }
            
       
//            let opt = try HTTP.POST("http://hometown.lookchallenge.com/api/Feed/PublishFeed?content="+content!+"&imagePath="+self.imagePath+"&parentFeeedID="+"", parameters: nil)
            
            let url="http://hometown.lookchallenge.com/api/Feed/PublishFeed"
            
            let queryItem1 = NSURLQueryItem(name: "content", value: content!)
            let queryItem2 = NSURLQueryItem(name: "imagePath", value: self.imagePath)
            let queryItem3 = NSURLQueryItem(name: "parentFeeedID", value: "")
            
            
            let urlComponents = NSURLComponents(string: url)!
            urlComponents.queryItems = [ queryItem1 as URLQueryItem,queryItem2 as URLQueryItem,queryItem3 as URLQueryItem ]
            let regURL = urlComponents.url!
            
            let opt = try HTTP.POST(regURL.description, parameters: nil)
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    if((response.text!)=="0")
                    {
                        //发布失败
                    }
                    else{
                        //跳转到老家信息视图
                         self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    
    //拍照
    func  takeImage()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "请选择", message:nil, preferredStyle: .actionSheet)
        //取消按钮
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //拍照
        let takePictureAction: UIAlertAction = UIAlertAction(title: "拍照", style: .default)
        { action -> Void in
            self.initWithImagePickView("拍照")
        }
        actionSheetController.addAction(takePictureAction)
        
        //相册选择
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "相册", style: .default)
        { action -> Void in
            
            self.initWithImagePickView("相册")
            
        }
        actionSheetController.addAction(choosePictureAction)
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    
    
    func initWithImagePickView(_ type:NSString){
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate      = self;
        self.imagePicker.allowsEditing = true;
        
        switch type{
        case "拍照":
            self.imagePicker.sourceType = .camera
            break
        case "相册":
            self.imagePicker.sourceType = .photoLibrary
            //self.imagePicker.sourceType = .SavedPhotosAlbum
            break
        default:
            print("error")
        }
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        

        imagePicker.dismiss(animated: true, completion: nil)
        
        var height:CGFloat=(image?.size.height)!
        
        var width:CGFloat=(image?.size.width)!
        
        if((image?.size.height)! > 300 )
        {
            
            height = 300
            width=width*300/height
        }
        
        if( (image?.size.width)!>300)
        {
            
            width = 300
            height=height*300/width
        }
        
        
        let smallerImage = imageWithImageSimple(image!, scaledToSize: CGSize(width: width,height: height))
        let data = UIImageJPEGRepresentation(smallerImage,0.5)
        
        showImage(image!)
        uploadImage(data!)
        
    }
    //显示图片
//    func showImage(_ image:UIImage)
//    {
//        let frontImageView=UIImageView()
//        frontImageView.image=image
//        frontImageView.frame=CGRect(x: 20,y: 150,width: 64,height: 64)
//
//        self.view.addSubview(frontImageView)
//
//    }
    
    func showImage(_ image:UIImage)
    {
        
        displayView.frame =  CGRect(x: 16, y: 144, width: 192, height: 64)
        self.view.addSubview(displayView)
        
        self.displayView.showImgs([image])

    }
    
    func imageWithImageSimple(_ image:UIImage,scaledToSize newSize:CGSize)->UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func  uploadImage(_ url:Data)
    {
        do {
            
            //hometown.lookchallenge.com
            let  opt=try HTTP.POST("http://hometown.lookchallenge.com/UploadHandler.ashx", parameters:["uploadFile": "UploadFile", "Filedata":Upload(data: url, fileName: "hh.jpg", mimeType: "image/jpeg")])
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    if((response.text!)=="0")
                    {
                        //上传失败
                    }
                    else{
                        self.imagePath += response.text! + "|"
                        print( response.text!)
                    }
                })
            }
            
        } catch let error {
            print("got an error: \(error)")
        }
        
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
