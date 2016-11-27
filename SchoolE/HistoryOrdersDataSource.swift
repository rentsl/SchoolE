//
//  NetManage.swift
//  SchoolE
//
//  Created by rentsl on 16/11/24.
//  Copyright © 2016年 rentsl. All rights reserved.
//

/** 从网络获取历史订单并转化为对应结构
  * @function getHistoryOrders       获取网络数据并进行处理
  * @function combineOrdersWithTime  将两个[OrderLocal]进行合并并通过时间排序
  */

import Foundation
import SocketIO
import SwiftyJSON

protocol historyOrdersProtocol {
    func historyOrdersListener(historyOrders: [OrderLocal])
}


var userLogin = LoginUser.sharedLoginUser


class HistoryOrdersDataSource{
    
    var delegate: historyOrdersProtocol?
    
    func getHistoryOrders(){
        print("启动getHistoryOrders")
        SocketConnect.socket.once("history published") { data,ack in
            let publishedHO = MyTools.socketIODataToJSON(data)
            guard publishedHO["result"].string == _success else {return}
            print("获取到history published订单")
            SocketConnect.socket.once("history grabbed", callback: { data,ack in
                let grabbedHO = MyTools.socketIODataToJSON(data)
                guard grabbedHO["result"].string == _success else {return}
                print("获取到history grabbed订单")
                let finalData = self.combineOrdersWithTime(
                    MyTools.JSONOrdersToOrders(publishedHO),
                    secondOrders: MyTools.JSONOrdersToOrders(grabbedHO)
                )
                self.delegate?.historyOrdersListener(finalData)
            })
            SocketConnect.socket.emit(
                "history grabbed",
                ["method":"history grabbed",
                "_id":userLogin._id,
                "token":userLogin.token]
            )
        }
        SocketConnect.socket.emit(
            "history published",
            ["method":"history published",
            "_id":userLogin._id,
            "token":userLogin.token]
        )
    }

    func combineOrdersWithTime(firstOrders:[OrderLocal],secondOrders:[OrderLocal]) -> [OrderLocal]{
        var newOrders:[OrderLocal] = []
        newOrders = firstOrders + secondOrders
        newOrders = newOrders.sort {$0.time > $1.time} //感觉赋值很蠢
        return newOrders
    }
    
}
