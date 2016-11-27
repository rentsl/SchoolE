//
//  RefuseOrder.swift
//  SchoolE
//
//  Created by rentsl on 16/11/25.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

@objc protocol RefuseOrderProtocol: NSObjectProtocol {
    optional func refuseSucceed(data:AnyObject)
    optional func beRefuse()
}

class RefuseOrder {
    var delegate: RefuseOrderProtocol?
    var userLocal = LoginUser.sharedLoginUser
    
    func refuseJudge(orderID:String){
        print("启动refuseJudge")
        SocketConnect.socket.once("order refuse") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _success else {return}
            print("拒接成功!")
            self.delegate?.refuseSucceed!(data)
        }
        SocketConnect.socket.emit(
            "order refuse",
            ["method":"order refuse",
                "_id":userLocal._id,
                "token":userLocal.token,
                "orderId":orderID]
        )
    }
    
    func refusedListener(){
        print("启动refusedListener")
        SocketConnect.socket.on("order refuse") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            guard dataJson["result"].string == _refused else {return}
            print("订单被拒绝")
            self.delegate?.beRefuse!()
        }
    }
}
