//
//  Feed.swift
//  Hometown
//
//  Created by ZouJP on 17/4/23.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import Foundation
import ObjectMapper

class Feed: Mappable {
    var FeedID: String?
        var Topic: String?
        var Content: String?
        var PersonnelID: String?
    
        var ProvinceID: Int?
        var CityID: Int?
        var TownID: Int?
        var VillageID: Int?
    
        var CreateDate: String?
        //var ImgPath: String?
        var ImgPathList: [String]?
        var ParentFeedID: String?
        var NikeName: String?
        var PicturePath: String?
    
        var FavorList: [FeedBack]?
        var CommentList: [FeedBack]?

    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        FeedID    <- map["FeedID"]
        Topic     <- map["Topic"]
        Content     <- map["Content"]
        PersonnelID     <- map["PersonnelID"]
        
        ProvinceID     <- map["ProvinceID"]
        CityID     <- map["CityID"]
        TownID     <- map["TownID"]
        VillageID     <- map["VillageID"]
        
        CreateDate     <- map["CreateDate"]
        //ImgPath     <- map["ImgPath"]
        ImgPathList <- map["ImgPathList"]
        ParentFeedID     <- map["ParentFeedID"]
        NikeName     <- map["NikeName"]
        PicturePath     <- map["PicturePath"]
        
         FavorList     <- map["FavorList"]
         CommentList     <- map["CommentList"]
        
    }
}

class Feeds: Mappable {
    
    var feeds: [Feed]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        feeds  <- map["Content"]
    }
}


//struct Feed:JSONJoy {
//
//    
//    var FeedID: String?
//    var Topic: String?
//    var Content: String?
//    var PersonnelID: String?
//    
//    var ProvinceID: Int?
//    var CityID: Int?
//    var TownID: Int?
//    var VillageID: Int?
//    
//    var CreateDate: String?
//    var ImgPath: String?
//    var ParentFeedID: String?
//    var NikeName: String?
//    var PicturePath: String?
//    
//    
//    
//    init(_ decoder: JSONDecoder) throws {
//        
//        FeedID = try decoder["FeedID"].get()
//        Topic =  try decoder["Topic"].get()
//        Content =  try decoder["Content"].get()
//        PersonnelID =  try decoder["PersonnelID"].get()
//        
//        ProvinceID =  try decoder["ProvinceID"].get()
//        CityID = try  decoder["CityID"].get()
//        TownID = try  decoder["TownID"].get()
//        VillageID =  try decoder["VillageID"].get()
//  
//        CreateDate =  try decoder["CreateDate"].get()
//        ImgPath =  try decoder["ImgPath"].get()
//        ParentFeedID =  try decoder["ParentFeedID"].get()
//        NikeName =  try decoder["NikeName"].get()
//        PicturePath =  try decoder["PicturePath"].get()
//
//    }
//    
//}
//
//
//struct Feeds : JSONJoy {
//    var feeds: [Feed]
//    
//    init(_ decoder: JSONDecoder) throws{
//        
//        feeds = try decoder["Content"].get()
//    
//    }
//}






//struct Feeds : JSONJoy {
//    var feeds: Array<Feed>?
//    init() {
//    }
//    
//    init(_ decoder: JSONDecoder) {
//        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
//        if let mods = decoder.array {
//            feeds = Array<Feed>()
//            
//            for modDecoder in mods {
//                feeds?.append(Feed(modDecoder))
//            }
//            
//        }
//    }
//}
