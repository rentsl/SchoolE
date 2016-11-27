//
//  ActiveOrdersListen.swift
//  SchoolE
//
//  Created by rentsl on 16/11/26.
//  Copyright © 2016年 rentsl. All rights reserved.
//
/**
  */

import Foundation

protocol ActiveOrdersListenProtocol {
    func activeOrderDidChange(state:String)  //active订单发生变化时返回变化订单(一个)
    func activeOrdersDidChange() //active订单发生变化时返回一堆订单
}

class ActiveOrdersListen {
    var delegate : ActiveOrdersListenProtocol?
    
    func activeOrderListener(){
        print("启动activeOrderListener")
        SocketConnect.socket.on("order changes") { data,ack in
            let dataJson = MyTools.socketIODataToJSON(data)
            let state = dataJson["changes"].string!
            self.delegate?.activeOrderDidChange(state)
        }
    }
    
    //没什么用
    func activeOrdersListener(){
        print("启动activeOrdersListener")
        SocketConnect.socket.on("orders changed") { data,ack in
            self.delegate?.activeOrdersDidChange()
        }
    }
    
}
