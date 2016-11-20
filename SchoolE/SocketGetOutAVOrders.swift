//
//  SocketGetOutAVOrders.swift
//  SchoolE
//
//  Created by rentsl on 16/11/17.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketGetOutAVOrders{
    var delegate: OutAvailableOrderslisten?
    
    func getOutAvailableOrders(){
        print("getOutAvailableOrders")
        SocketConnect.socket.on("published order") { data,ack in
            self.delegate?.getNewOutAvailableOrders(data)
            print("从服务器取到OutAvailableOrders")
        }
    }
}
