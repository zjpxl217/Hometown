//
//  City.swift
//  Hometown
//
//  Created by ZouJP on 17/5/7.
//  Copyright © 2017年 ZouJP. All rights reserved.
//
import ObjectMapper


class City:Mappable {
    
    var CityID: Int?
    var CityName: String?
    var Description: String?
    var Zip: String?
    var ProvinceID: Int?
    var CreateDate: String?
    
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        CityID     <- map["CityID"]
        CityName     <- map["CityName"]
        ProvinceID     <- map["ProvinceID"]
        Description     <- map["Description"]
        Zip     <- map["Zip"]
        CreateDate     <- map["CreateDate"]
        
        
        
    }
    
    
}

class Citys: Mappable {
    
    var citys: [City]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        citys  <- map["Content"]
    }
}





//import JSONJoy
//
//struct City:JSONJoy {
//    
//    var CityID: Int?
//    var CityName: String?
//    var Description: String?
//    var Zip: String?
//    var ProvinceID: Int?
//    var CreateDate: String?
//    
//    init(_ decoder: JSONDecoder) throws {
//        
//        CityID = try decoder["CityID"].get()
//        CityName =  try decoder["CityName"].get()
//        Description =  try decoder["Description"].get()
//        Zip =  try decoder["Zip"].get()
//        ProvinceID =  try decoder["ProvinceID"].get()
//        CreateDate =  try decoder["CreateDate"].get()
//    }
//    
//}
//
//struct Citys:JSONJoy{
//    let citys:[City]
//    
//    init(_ decoder: JSONDecoder) throws{
//       citys=try decoder["citys"].get()
//    }
//}

