//
//  ConfirmOder.swift
//  SchoolE
//
//  Created by rentsl on 16/11/25.
//  Copyright © 2016年 rentsl. All rights reserved.
//
/** 对确认订单事件的处理
 * @function comfirmJudge       确认订单,正确时返回结果(发单者)
 * @function comfirmedListener  监听抢到的订单是否被确认(抢单者)
 */

import Foundation
import SocketIO

@objc protocol ConfirmOrderProtocol: NSObjectProtocol {
    optional func comfirmSucceed(data:AnyObject)
    optional func beComfirmed()
}

class ConfirmOrder {
    var delegate: ConfirmOrderProtocol?
    var userLocal = LoginUser.sharedLoginUser
    
    func comfirmJudge(orderID:String){
        print("启动comfirmJudge")
        SocketConnect.socket.once("order confirm") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _success else {return}
            print("确认成功!")
            self.delegate?.comfirmSucceed!(data)
        }
        SocketConnect.socket.emit(
            "order confirm",
            ["method":"order confirm",
             "_id":userLocal._id,
             "token":userLocal.token,
             "orderId":orderID]
        )
    }
    
    func comfirmedListener(){
        print("启动comfirmedListener")
        SocketConnect.socket.on("order confirm") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _confirmed else {return}
            print("订单被确认")
            self.delegate?.beComfirmed!()
        }
    }
}
