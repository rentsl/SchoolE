//
//  MyTools.swift
//  SchoolE
//
//  Created by rentsl on 16/11/23.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyTools{
    //将data转成JSON格式
    static func socketIODataToJSON(data: AnyObject) -> JSON{
        let dataString = String((data as! NSArray)[0])
        let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let dataJson = JSON(data:jsonData!)
        return dataJson
    }
    
    //json转Orders(不安全)
    static func JSONOrdersToOrders(dataJson: JSON) -> [OrderLocal]{
        var ordersLocal:[OrderLocal] = []
        for i in 0..<dataJson["data"].count{
            ordersLocal.append(OrderLocal(
                publisherImage: UIImagePNGRepresentation(UIImage(named: "b004")!),
                publisherName: dataJson["data"][i]["publisher_name"].string!,
                location: dataJson["data"][i]["location"].string!,
                status: dataJson["data"][i]["status"].string!,
                detail: dataJson["data"][i]["detail"].string!,
                cost: String(dataJson["data"][i]["cost"]),
                publisherTel: String(dataJson["data"][i]["phone"]),
                time: dataJson["data"][i]["time"].string!,
                publisherID: dataJson["data"][i]["publisher"].string!,
                id: dataJson["data"][i]["_id"].string!,
                receiver: dataJson["data"][i]["receiver"].string!,
                publisherImageID: dataJson["data"][i]["publisher_avatar"].string!)
            )
        }
        return ordersLocal
    }
    
}
