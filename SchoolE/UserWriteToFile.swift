//
//  UserWriteToFile.swift
//  SchoolE
//
//  Created by rentsl on 16/11/10.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
class UserWriteToFile {
    static internal var userLogin = LoginUser.sharedLoginUser
    static func writeToFile() {
        //写入文件的数据
        let dic: NSMutableDictionary = [
            "name":self.userLogin.name,
            "paynumber":self.userLogin.paynumber,
            "school":self.userLogin.school,
            "studentID":self.userLogin.studentID,
            "userTel":self.userLogin.userTel,
            "userName":self.userLogin.userName,
            "password":self.userLogin.password,
            "userImage":self.userLogin.userImage!,
            "state":self.userLogin.state,
            "_id":self.userLogin._id,
            "authenticated":self.userLogin.authenticated,
            "token":self.userLogin.token
        ]
        
        //创建文件
        /*3******************************************/
        var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        if sp.count > 0 {
            let url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
            dic.writeToFile(url.path!, atomically: true)
            print(url)
        }

        /*3******************************************/
    }
}
