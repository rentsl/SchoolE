//
//  MyProtocol.swift
//  SchoolE
//
//  Created by rentsl on 16/11/13.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation

protocol ChangeLable: NSObjectProtocol {
    func changeLable(text:String)
}

protocol AvailableOrderslisten: NSObjectProtocol {
    func getNewAvailableOrders(data: AnyObject)
}

protocol OutAvailableOrderslisten: NSObjectProtocol {
    func getNewOutAvailableOrders(data: AnyObject)
}

protocol GetActiveOrdersListen: NSObjectProtocol {
    func getNewGetActiveOrders(data: AnyObject)
}

protocol DownLoadImgeProtocol: NSObjectProtocol {
    func getDownImage(index: Int, imageData: NSData , info: String)
}

protocol GrabOrderListen: NSObjectProtocol {
    func grabOrder(data: AnyObject)
}
