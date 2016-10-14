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
    
    var userName = "未登录"
    var userImage = UIImagePNGRepresentation(UIImage(named:"b004")!)
    var userTel = "18906622309"
    var password = "31001453r"
    var school = "HDU"
    var name = "rentsl"
    var studentID = "13055827"
    var paynumber = "18906622309"
    var state = 0
    
}
