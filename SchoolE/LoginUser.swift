//
//  LoginUser.swift
//  SchoolE
//
//  Created by rentsl on 16/10/13.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginUser: NSObject {
    internal static let sharedLoginUser = LoginUser()
    private override init() {
            print("产生单例")
    }
    
    var userName = "请登录"
    var userImage = UIImagePNGRepresentation(UIImage(named:"b004")!)
    var userTel = ""
    var password = ""
    var school = ""
    var name = ""
    var studentID = ""
    var paynumber = ""
    var state: Int = 0
    var token = ""
    var _id = ""
    var authenticated = ""
}
