//
//  FeedCell.swift
//  Hometown
//
//  Created by ZouJP on 17/5/6.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import UIKit


typealias heightChange = (_ cellFlag:Bool) -> Void
//赞
typealias likeChange = (_ cellFlag:Bool) -> Void
//评论
typealias commentChange = () -> Void
//回复
typealias answerChange = (_ replayToID:String)->Void

class FeedCell: UITableViewCell {
    
    var flag = true
    var likeflag = true
    var  feedID = ""
   
    var cellflag1 = false
    var heightZhi:heightChange?
    var collectionViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var displayView = DisplayView()
    let userImageView = DisplayView()
    let menuview = Menu()
    var commentchange:commentChange?
    var answerchange:answerChange?
    var likechange:likeChange?
    
    let pbVC = PhotoBrowser()
    //👍
    var likeView = UIView()
    //评论
    var commnetView = UIView()
    
  
    //保存回复人员ID
    var personnelIDDic : [Int : String] = [:]
    
    //发布的图片
    @IBOutlet weak var publishImage: UIImageView!
    //发布的内容
    @IBOutlet weak var content: UILabel!
    //用户名
    @IBOutlet weak var userName: UILabel!
    //用户头像
    @IBOutlet weak var userImagePath: UIImageView!
    //内容发布时间
    @IBOutlet weak var publishTime: UILabel!
    
    //评论
    @IBOutlet weak var addCommentBtn: UIButton!
    
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func SetUserImageProperty(_ userImagePathUrl:String)
    {
          userImagePath.hnk_setImageFromURL(URL(string: userImagePathUrl)!)
    }
    
    
    func SetContentProperty(_ feedContent:String,indexRow:IndexPath,selectItem:Bool,remoteImage:[String],
                            favorList:[FeedBack],commentList:[FeedBack])
    {
        let h_content = CellHelper.cellHeightByData(feedContent)
        let h_image = CellHelper.cellHeightByImage(1)
        
        var h2:CGFloat = 0.0
        
        //防止重复添加，先 从父视图 将自己清空
        displayView.removeFromSuperview()
        displayView = DisplayView()
        
       
        if !selectItem{
            cellflag1 = !selectItem
            content.frame = CGRect(x: 60, y: 30, width: UIScreen.main.bounds.width - 60 - 10, height: h_content)
            collectionViewFrame = CGRect(x: 60, y: h_content+10+20, width: 220, height: h_image)
        }else{
            cellflag1 = !selectItem
            content.frame = CGRect(x: 60, y: 30, width: UIScreen.main.bounds.width - 60 - 10, height: h_content)
            collectionViewFrame = CGRect(x: 60, y: h_content+10+20, width: 220, height: h_image)
        }
        
        h2 = h_image + h_content + 27
        
        displayView.frame = collectionViewFrame
        self.contentView.addSubview(displayView)
        
        displayView.imgsPrepare(remoteImage, isLocal: false)
        
        pbVC.showType = .modal
        pbVC.photoType = PhotoBrowser.PhotoType.host
        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
        
        var models:[PhotoBrowser.PhotoModel] = []
       
        for i in 0 ..< remoteImage.count{
            let model = PhotoBrowser.PhotoModel(hostHDImgURL:remoteImage[i], hostThumbnailImg: (displayView.subviews[i] as! UIImageView).image, titleStr: "", descStr: "", sourceView: displayView.subviews[i])
            models.append(model)
        }
        
        pbVC.photoModels = models
        
        //时间按钮
        publishTime.frame = CGRect(x: 65, y: h2, width: 150, height: 12)
        
        
        let commentY = h2+12        
        SetFeedBackProperty(favorList: favorList, commentList: commentList, y: commentY)
        
        
        //添加评论按钮
        addCommentBtn.frame =  CGRect(x: 0, y: h2, width: 15, height: 12)
        addCommentBtn.frame.origin.x = UIScreen.main.bounds.width - 10 - 15
        addCommentBtn.addTarget(self, action: #selector(FeedCell.click), for: .touchUpInside)
        
        //菜单按钮（点赞，评论）
        self.menuview.frame = CGRect(x:0, y:h2-12, width:14.5, height:0)
        self.menuview.frame.origin.x = UIScreen.main.bounds.width - 10 - 15
        self.menuview.likeBtn.setImage(UIImage(named: "likewhite"), for: .normal)
        
       
        let likeItem = favorList.contains{ (feedback)-> Bool in            
            return  feedback.PersonnelID == appDelegate.currentPerson?.PersonnelID
        }
        
        if !likeItem{
            self.menuview.likeBtn.setTitle("赞", for: .normal)
            likeflag = !likeItem
        }
        if likeItem{
            self.menuview.likeBtn.setTitle("取消赞", for: .normal)
            likeflag = !likeItem
        }
        
        self.menuview.likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.menuview.commentBtn.setImage(UIImage(named: "c"), for: .normal)
        self.menuview.commentBtn.setTitle("评论", for: .normal)
        self.menuview.commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.menuview.likeBtn.tag = indexRow.row
        self.menuview.likeBtn.addTarget(self, action: #selector(FeedCell.LikeBtn), for: .touchUpInside)
        self.menuview.commentBtn.addTarget(self, action: #selector(FeedCell.CommentBtn), for: .touchUpInside)
        
        self.contentView.addSubview(self.menuview)
    }
    //展现👍 和 评论
    func SetFeedBackProperty(favorList:[FeedBack],commentList:[FeedBack],y:CGFloat)
    {
        var likeHeight:CGFloat = 0.0
        //如果存在 👍
        if(favorList.count>0)
        {
            
//            let  like = UIImageView()
//            like.frame=CGRect(x: 4, y: 2, width: 14, height: 14)
//            like.image=UIImage(named: "u2")
//            
           
            self.likeView = UIView()
            self.likeView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            
            var  likeName="♡ "
            
            for item in favorList{
                likeName+=item.PersonnelName!+","
            }
            
            let index = likeName.index(likeName.endIndex, offsetBy: -1)
            likeName = likeName.substring(to: index)
            likeHeight=CellHelper.cellHeightByData(likeName)
           
            let likeLableName=UILabel()
            likeLableName.frame=CGRect(x: 4, y: 0, width:UIScreen.main.bounds.width - 60 - 10, height: likeHeight)
            likeLableName.text = likeName
            likeLableName.font = UIFont.systemFont(ofSize: 14)
            likeLableName.textColor=UIColor(red: 120/255, green: 167/255, blue: 240/255, alpha: 1)
            
           
            self.likeView.frame = CGRect(x: 60, y: y+10, width: UIScreen.main.bounds.width - 60 - 10, height: likeHeight)

            
            //self.likeView.addSubview(like)
            self.likeView.addSubview(likeLableName)
            
            self.contentView.addSubview(self.likeView)

        }
        
        personnelIDDic = [Int : String]()
        //如果存在评论
        if(commentList.count>0)
        {
            
            self.commnetView = UIView()
            
            //let h_comment = CellHelper.cellHeightByCommentNum(commentList.count)
            var h_comment:CGFloat=0.0
            
            
            var y_comment:CGFloat = 0
            var personnelID_index = 0
            for item in  commentList{
 
                personnelIDDic[personnelID_index] = item.PersonnelID
                
                
                //item.Content =  "评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论"
                //item.ReplyToName = "张三"
                var  commnetContent:String = ""
                
                if(item.ReplyToName != "")
                {
                      commnetContent = item.PersonnelName! + " 回复 " + item.ReplyToName! + ":"+item.Content!
                }else{
                      commnetContent = item.PersonnelName! + ":" + item.Content!
                }
                
                
                let lableHeight=CellHelper.cellHeightByData(commnetContent)
                h_comment+=lableHeight

                let label = UILabel(frame:CGRect(x:5, y:y_comment, width:UIScreen.main.bounds.width - 60 - 15, height:lableHeight))
                label.font = UIFont.systemFont(ofSize: 14)
                label.numberOfLines=0
                label.attributedText=FuWenBen(fromWho: item.PersonnelName!,toWho: item.ReplyToName!,feedBack: item.Content!)
                
        
                //用户交互功能打开状态
                label.isUserInteractionEnabled=true
                //点击事件
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(FeedCell.Answer))
                label.tag = personnelID_index
                
                //绑定tap
                label.addGestureRecognizer(tap)
                
                
                y_comment+=lableHeight
                
                personnelID_index += 1
                
                self.commnetView.addSubview(label)
                
            }
            
            self.commnetView.frame = CGRect(x: 60, y: y+10+likeHeight+1, width: UIScreen.main.bounds.width - 60 - 10, height: h_comment)
            self.commnetView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            
            
            self.contentView.addSubview(self.commnetView)
            
        }
        
        
    }
    
    func FuWenBen( fromWho:String, toWho:String,feedBack:String)->NSMutableAttributedString
    {
        //定义富文本即有格式的字符串
        var fromWho = fromWho
        var toWho = toWho
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if(toWho == "")
        {
           fromWho = fromWho+":"
        }else{
           toWho = toWho+":"
        }
        
        //邱学伟
        let fromWhoAttr : NSAttributedString = NSAttributedString(string: fromWho, attributes: [NSForegroundColorAttributeName : UIColor.init(red: 120/255, green: 167/255, blue: 240/255, alpha: 1), NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14.0)])
        
        attributedStrM.append(fromWhoAttr)
        
        if(toWho != "")
        {
            let answer : NSAttributedString = NSAttributedString(string: " 回复 ", attributes: [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)])
            //大帅哥
            let toWhoAttr : NSAttributedString = NSAttributedString(string: toWho, attributes: [NSForegroundColorAttributeName : UIColor.init(red: 120/255, green: 167/255, blue: 240/255, alpha: 1), NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)])

            attributedStrM.append(answer)
            attributedStrM.append(toWhoAttr)
        
        }
        
        let feedBackContent : NSAttributedString = NSAttributedString(string: feedBack, attributes: [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)])
        
         attributedStrM.append(feedBackContent)
        
      return attributedStrM
    }
    
    //回复
    func Answer(sender:UITapGestureRecognizer)
    {

        if self.answerchange != nil{
            
            print(sender.view!.tag)
            self.answerchange!(personnelIDDic[sender.view!.tag]!)
        }
    }
    
    
    func click(){
        menuview.clickMenu()
    }

    func CommentBtn(sender:UIButton){
        if self.commentchange != nil{
            self.commentchange!()
        }
        menuview.menuHide()
    }

    func LikeBtn(sender:UIButton){
        
        if !likeflag{
            //服务器接口上传数据
            if self.likechange != nil{
                self.likechange!(self.likeflag)
            }
        }
        else{
            if self.likechange != nil{
                self.likechange!(self.likeflag)
            }
        }
        menuview.menuHide()
        
    }

    
    func clickDown(_ sender:UIButton){
        
        if flag{
            flag = false
            if self.heightZhi != nil{
                self.heightZhi!(self.cellflag1)
            }
            
        }
        else{
            flag = true
            if self.heightZhi != nil{
                self.heightZhi!(self.cellflag1)
            }
        }
        
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
