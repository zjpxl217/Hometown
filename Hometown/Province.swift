//
//  Province.swift
//  Hometown
//
//  Created by ZouJP on 17/5/7.
//  Copyright © 2017年 ZouJP. All rights reserved.
//



import ObjectMapper

//{"ProvinceID":1,"ProvinceName":"北京市","Description":"","CountryID":0}
       
class Province:Mappable {
    
    var ProvinceID: Int?
    var ProvinceName: String?
    var Description: String?
    var CountryID: Int?
    
   
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        ProvinceID     <- map["ProvinceID"]
        ProvinceName     <- map["ProvinceName"]
        Description     <- map["Description"]
        CountryID     <- map["CountryID"]
        
        
    }
    
    
}

class Provinces: Mappable {
    
    var provinces: [Province]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        provinces  <- map["Content"]
    }
}






