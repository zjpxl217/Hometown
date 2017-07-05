//: Playground - noun: a place where people can play

import UIKit
import JSONJoy
import SwiftHTTP
import ObjectMapper

func simpleQueues() {
    
    // 说明:当前在主线程上执行
    
    let queue = DispatchQueue(label: "com.appcoda.myqueue", qos: .background)
    
    
    
    queue.sync {
        
        print("????", 0)
        
    }
    
    DispatchQueue.main.sync {
        
        print("??", 0)
        
    }
    
}


//var str = "Hello, playground"
//

let  hh = "{\"addresses\":[{\"id\": 1,\"street_address\": \"2nd Street\",\"city\":\"Bakersfield\",\"state\": \"CA\",\"postal_code\": 93309},{\"id\": 2,\"street_address\": \"2nd Street\",\"city\": \"Dallas\",\"state\": \"TX\",\"postal_code\": 12345}]}"


class Address: Mappable {
    var id: String?
    var street_address: String?
    var city: String?
    var state: String?
    var postal_code: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        street_address     <- map["street_address"]
        city     <- map["city"]
        state     <- map["state"]
        postal_code     <- map["postal_code"]
        
    }
}

class Addresses: Mappable {
    
    var addresses: [Address]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        addresses  <- map["addresses"]
    }
}

let addresses = Addresses(JSONString: hh)

print(addresses?.addresses?.first?.city)




let jsonStr = "{\"name\": \"hangge\", \"age\": 1090}"

let jsonAarry = "[{\"name\": \"hangge\", \"age\": 1090}, {\"name\": \"big boss\",\"age\": 1}]"

class User: Mappable {
    var name: String?
    var age: Int?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        name    <- map["name"]
        age     <- map["age"]
        
    }
}

class Friend: Mappable {
    
    var friends: [User]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        friends  <- map
    }
}



let user = User(JSONString: jsonStr)

print(user?.age)

let friend=Friend(JSONString: jsonAarry)

print(friend?.friends?.count ?? 0)


//
//
//
//struct People:JSONJoy {
//    let age: Int?
//    let name: String?
//    init(_ decoder: JSONDecoder) throws {
//
//        age = try decoder["age"].get()
//        name = try decoder["name"].get()
//
//    }
//}
//
//struct User:JSONJoy{
//    let peoples:[People]
//    init(_ decoder: JSONDecoder) throws {
//        peoples = try decoder.get() //infers the type and returns a valid array
//    }
//}
//
//let jsonData:Data = jsonStr.data(using: .utf8)!
//
//
//do {
//    var user = try User(JSONDecoder(jsonData))
//
//    print(user.peoples.count)
//
//    print("age is: \(String(describing: user.peoples.first?.age!))")
//    //That's it! The object has all the appropriate properties mapped.
//} catch {
//    print("unabley to parse the JSON")
//}

//
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
//    init(_ decoder: JSONDecoder)  throws {
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
//        feeds = try decoder.get()
//
//    }
//}
//
//do {
//
//    let date:Date = Date()
//
//    // 创建时间戳
//    let formatter:DateFormatter = DateFormatter()
//
//    // 设置日期格式，以字符串表示的日期形式的格式
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//    // 转换成指定的格式
//    let createDate:String = formatter.string(from: date)
//
//
//    let opt = try HTTP.GET("http://hometown.lookchallenge.com/api/Feed/GetFeedListByObjectID", parameters: ["objectID":"9","createDate":createDate,"areaType":"Province"])
//
//    opt.start { response in
//        if let error = response.error {
//            print("got an error: \(error)")
//            return
//        }
//
//        print("got an error: 1")
//
//
//        DispatchQueue.main.async(execute: {
//                                ()-> Void in
//            let jsonData:Data = response.text!.data(using: .utf8)!
//            let feedList = try Feeds(JSONDecoder(jsonData))
//        } as! @convention(block) () -> Void)
//
//
//    }
//} catch let error {
//    print("got an error creating the request: \(error)")
//}
