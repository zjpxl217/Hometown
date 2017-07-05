//
//  Personnel.swift
//  Hometown
//
//  Created by ZouJP on 17/5/10.
//  Copyright © 2017年 ZouJP. All rights reserved.
//

import ObjectMapper


class Personnel: Mappable {
    
    var CityID: Int?
    var VillageID: Int?
    var ProvinceID: Int?
    var TownID: Int?
    var PersonnelID:String?
    var PicturePath:String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        CityID    <- map["CityID"]
        VillageID     <- map["VillageID"]
        ProvinceID     <- map["ProvinceID"]
        TownID     <- map["TownID"]
        
        PersonnelID     <- map["PersonnelID"]
        PicturePath     <- map["PicturePath"]
       
        
    }
}

class Personnels: Mappable {
    
    var personnels: [Personnel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        personnels  <- map["Content"]
    }
}


//struct Personnel:JSONJoy {
//    
//    var CityID: Int?
//    var VillageID: Int?
//    var ProvinceID: Int?
//    var TownID: Int?
//    var PersonnelID:String?
//    
//    init(_ decoder: JSONDecoder) throws{
//        
//        PersonnelID = try decoder["PersonnelID"].get()
//        
//        CityID = try decoder["CityID"].get()
//        VillageID = try decoder["VillageID"].get()
//        TownID = try decoder["TownID"].get()
//        ProvinceID = try decoder["ProvinceID"].get()
//    }
//    
//}
//struct Personnels : JSONJoy {
//    var personnels: [Personnel]
//    
//    init(_ decoder: JSONDecoder) throws{
//        personnels = try decoder["personnels"].get()
//    }
//}



//struct Personnels : JSONJoy {
//    var personnels: Array<Personnel>?
//    init() {
//    }
//    init(_ decoder: JSONDecoder) {
//        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
//        if let mods = decoder.array {
//            personnels = Array<Personnel>()
//            for modDecoder in mods {
//                personnels?.append(Personnel(modDecoder))
//            }
//        }
//    }
//}
