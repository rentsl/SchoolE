//
//  MyProtocol.swift
//  SchoolE
//
//  Created by rentsl on 16/11/13.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation

protocol ChangeLable {
    func changeLable(text:String)
}

protocol AvailableOrderslisten {
    func getNewAvailableOrders(data: AnyObject)
}

protocol DownLoadImgeProtocol: NSObjectProtocol {
    func getDownImage(index: Int, imageData: NSData)
}
