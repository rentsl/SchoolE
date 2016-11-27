//
//  SocketGetGetActiveOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

protocol GetActiveOrdersProtocol: NSObjectProtocol {
    func getActiveOrdersListener(data: [OrderLocal])
}

class SocketGetGetActiveOrders{
    var delegate:GetActiveOrdersProtocol?
    var userLocal = LoginUser.sharedLoginUser
    
    func getGetActiveOrders(){
        print("启动getGetActiveOrders")
        SocketConnect.socket.once("grabbed order") { data,ack in
            let getActiveOrders = MyTools.socketIODataToJSON(data)
            guard getActiveOrders["result"].string == _success else {return}
            print("获取到getActiveOrders订单")
            //print(getActiveOrders)
            let finalOrders = MyTools.JSONOrdersToOrders(getActiveOrders)
            self.delegate?.getActiveOrdersListener(finalOrders)
        }
        SocketConnect.socket.emit(
            "grabbed order",
            ["method":"grabbed order",
            "_id":userLocal._id,
            "token":userLocal.token]
        )
    }
}
