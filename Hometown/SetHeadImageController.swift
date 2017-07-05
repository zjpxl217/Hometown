//
//  SetHeadImageController.swift
//  Hometown
//
//  Created by ZouJP on 2017/6/20.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class SetHeadImageController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
    @IBOutlet weak var headImage: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let item = UIBarButtonItem(barButtonSystemItem:.camera, target: self, action: #selector(SetHeadImageController.takeImage))
        
        self.navigationItem.rightBarButtonItem=item

        
        GetHeadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func GetHeadImage()
    {
        do {
            
            let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Account/Get", parameters: nil)
            
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    return
                }
                //加入主线程
                DispatchQueue.main.async(execute: {
                    ()-> Void in
                    
                    let personnel = Personnel(JSONString:response.text!)
                    self.headImage.hnk_setImageFromURL(URL(string: (personnel?.PicturePath)!)!)
                   
                } as @convention(block) () -> Void)
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
        self.imagePicker.delegate      = self
        self.imagePicker.allowsEditing = true
        
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
 
    
    func showImage(_ image:UIImage)
    {
        self.headImage.image = image
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
            let  opt=try HTTP.POST("http://hometown.lookchallenge.com/UploadHandler.ashx", parameters:["uploadFile": "UserPicture", "Filedata":Upload(data: url, fileName: "hh.jpg", mimeType: "image/jpeg")])
            
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
                        
                        self.UpdatePicturePath( picturePath: response.text!)
                    }
                })
            }
            
        } catch let error {
            print("got an error: \(error)")
        }
    }
    
    //更新头像
    func UpdatePicturePath(picturePath:String)
    {
        do {
            
           
            let url="http://hometown.lookchallenge.com/api/Account/UpdatePicturePath"
            
            let queryItem1 = NSURLQueryItem(name: "picturePath", value: picturePath)
            
            let urlComponents = NSURLComponents(string: url)!
            urlComponents.queryItems = [ queryItem1 as URLQueryItem]
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

                    
                } as @convention(block) () -> Void)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
