//
//  SocketGrabOrder.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketGrabOrder{
    var delegate: GrabOrderListen?
    
    func grabOrder(){
        print("grabOrder")
        SocketConnect.socket.on("order grab") { data,ack in
            self.delegate?.grabOrder(data)
            print("抢单成功!")
        }
    }
}
