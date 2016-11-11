//
//  SocketConnect.swift
//  SchoolE
//
//  Created by rentsl on 16/11/10.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketConnect: NSObject {
    //static internal let sharedSocket = SocketConnect()
    static internal let socket = SocketIOClient(socketURL: NSURL(string: "ws://121.42.186.184:3000")!, config: [])
    private override init() {
        print("生成Socket连接单例")
    }
    
    static func socketConnect() {
        //.Log(true), .ForcePolling(true)
        
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.on( "currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
                    socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
      
    }
    
}
