//
//  MyURLs.swift
//  SchoolE
//
//  Created by rentsl on 16/11/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation

class MyURLs {
    //本地
    //static let urlHeader = "60.176.39.70:3000"
    //阿里云
    static let urlHeader = "121.42.186.184:3000"
    static let urlLogIn = "http://"+MyURLs.urlHeader+"/login"
    static let urlDownHeader = "http://"+MyURLs.urlHeader+"/images/"
    static let urlSginUp = "http://"+MyURLs.urlHeader+"/reg"
    static let urlTokenLogin = "http://"+MyURLs.urlHeader+"/token_login"
    static let urlUpLoadAvatar = "http://"+MyURLs.urlHeader+"/upload_avatar"
    static let urlImageDownTest = "http://"+MyURLs.urlHeader+"/images/1.png"
    static let urlSocketConnect = "ws://"+MyURLs.urlHeader
}
