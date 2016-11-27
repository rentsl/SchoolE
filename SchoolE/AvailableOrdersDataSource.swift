//
//  SocketGetAvailableOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

protocol AvailableOrdersProtocol: NSObjectProtocol {
    func availableOrdersListener(data: [OrderLocal])
}

class AvailableOrdersDataSource{
    var userLogin = LoginUser.sharedLoginUser
    var delegate: AvailableOrdersProtocol?
    
    func getAvailableOrders(userID:String){
        print("启动getAvailableOrders")
        SocketConnect.socket.once("get orders", callback: { data,ack in
            let availableOrders = MyTools.socketIODataToJSON(data)
            print("获取到AvailableOrders订单")
            var noImageOrders: [OrderLocal] = []
            noImageOrders = MyTools.JSONOrdersToOrders(availableOrders)
            noImageOrders = noImageOrders.filter{ $0.publisherID != self.userLogin._id } //去掉自己发的订单
            self.delegate?.availableOrdersListener(noImageOrders)
        })
        SocketConnect.socket.emit("get orders", "hi")
    }
}
