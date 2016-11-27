//
//  SocketGrabOrder.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//
/** 对抢单事件和被抢订单的处理
  * @function grabOrderJudge     请求抢单,正确时返回结果(抢单者)
  * @function grabOrderListener  监听发出的订单是否被抢(发单者)
  */

import Foundation
import SocketIO

@objc protocol GrabOrderProtocol: NSObjectProtocol {
    optional func grabSucceed(data: AnyObject)
    optional func beGrabbed(data: AnyObject)
}



class SocketGrabOrder{
    var delegate: GrabOrderProtocol?
    
    func grabOrderJudge(orderID:String){
        print("启动grabOrderJudge")
        SocketConnect.socket.once("order grab") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _success else {return}
            print("抢单成功!")
            self.delegate?.grabSucceed!(data)
        }
        SocketConnect.socket.emit(
            "order grab",
            ["method":"order grab",
             "_id":userLogin._id,
             "token":userLogin.token,
             "orderId":orderID]
        )
    }
    
    func grabOrderListener(){
        print("启动grabOrderListener")
        SocketConnect.socket.on("order grab") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _grabbed else {return}
            print("有人抢单!")
            self.delegate?.beGrabbed!(data)
        }
    }
}
