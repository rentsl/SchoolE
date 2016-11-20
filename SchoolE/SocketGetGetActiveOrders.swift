//
//  SocketGetGetActiveOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketGetGetActiveOrders{
    var delegate:GetActiveOrdersListen?
    func getGetActiveOrders(){
        print("getGetActiveOrders")
        SocketConnect.socket.on("grabbed order") { data,ack in
            self.delegate?.getNewGetActiveOrders(data)
            print("从服务器取到GetActiveOrders")
        }
    }
}
