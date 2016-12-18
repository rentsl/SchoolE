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
    //static let urlHeader = "121.42.186.184:3000"
    //腾讯云
    static let urlHeader = "115.159.149.127:3000"
    static let urlLogIn = "http://"+MyURLs.urlHeader+"/login"
    static let urlDownHeader = "http://"+MyURLs.urlHeader+"/images/"
    static let urlSginUp = "http://"+MyURLs.urlHeader+"/reg"
    static let urlTokenLogin = "http://"+MyURLs.urlHeader+"/token_login"
    static let urlUpLoadAvatar = "http://"+MyURLs.urlHeader+"/upload_avatar"
    static let urlImageDownTest = "http://"+MyURLs.urlHeader+"/images/1.png"
    static let urlSocketConnect = "ws://"+MyURLs.urlHeader
    static let urlUpdateProfire = "http://"+MyURLs.urlHeader+"/update_profile"
}

enum NetResponeResult: String {
    case success   = "success"
    case grabbed   = "grabbed"
    case confirmed = "confirmed"
    case refused   = "refused"
    case finished  = "finished"
}

let _success   = NetResponeResult.success.rawValue
let _grabbed   = NetResponeResult.grabbed.rawValue
let _confirmed = NetResponeResult.confirmed.rawValue
let _refused   = NetResponeResult.refused.rawValue
let _finished  = NetResponeResult.finished.rawValue

//changes
let _new       = "new"
let _remove    = "remove"
let _vary      = "vary"
