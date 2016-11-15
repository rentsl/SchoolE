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
        print("11111")
        if delegate != nil {
            SocketConnect.socket.on("get orders", callback: { data,ack in
                self.delegate?.getNewAvailableOrders(data)
                print("22222")
            })
        }
    }
    
}
