//
//  SocketGetOutAVOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/17.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

protocol OutAvailableOrdersProtocol: NSObjectProtocol {
    func outAvailableOrdersListener(data: [OrderLocal])
}

class SocketGetOutAVOrders{
    var delegate: OutAvailableOrdersProtocol?
    var userLocal = LoginUser.sharedLoginUser
    
    func getOutAvailableOrders(){
        print("启动getOutAvailableOrders")
        SocketConnect.socket.once("published order") { data,ack in
            let outActiveOrders = MyTools.socketIODataToJSON(data)
            guard outActiveOrders["result"].string == _success else {return}
            print("获取到outActiveOrders订单")
            let finalOrders = MyTools.JSONOrdersToOrders(outActiveOrders)
            self.delegate?.outAvailableOrdersListener(finalOrders)
        }
        SocketConnect.socket.emit(
            "published order",
            ["method":"published order",
             "_id":userLocal._id,
             "token":userLocal.token]
        )
    }
}
