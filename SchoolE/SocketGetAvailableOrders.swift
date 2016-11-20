//
//  SocketGetAvailableOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketGetAvailableOrders{
    var delegate: AvailableOrderslisten?
    
    func getAvailableOrders(){
        print("getAvailableOrders")
        if delegate != nil {
            SocketConnect.socket.on("get orders", callback: { data,ack in
                self.delegate?.getNewAvailableOrders(data)
                print("从服务器取到AvailableOrders")
            })
        }
    }
    
}
