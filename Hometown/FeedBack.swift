//
//  FeedBack.swift
//  Hometown
//
//  Created by ZouJP on 2017/6/24.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation

import ObjectMapper

class FeedBack: Mappable {
   
    var FeedID: String?
    var ParentFeedID: String?
    var Content: String?
    var PersonnelID: String?
    var CreateDate: String?
    var ReplyTo:String?
    var PersonnelName:String?
    var ReplyToName:String?
  
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        FeedID    <- map["FeedID"]
        Content     <- map["Content"]
        PersonnelID     <- map["PersonnelID"]
        CreateDate     <- map["CreateDate"]
        ParentFeedID     <- map["ParentFeedID"]
        ReplyTo     <- map["ReplyTo"]
        PersonnelName     <- map["PersonnelName"]
        ReplyToName     <- map["ReplyToName"]
        
    }
}

//class FeedBacks: Mappable {
//    
//    var feedBacks: [FeedBack]?
//    
//    required init?(map: Map) {
//        
//    }
//    
//    func mapping(map: Map) {
//        feedBacks  <- map["Content"]
//    }
//}
