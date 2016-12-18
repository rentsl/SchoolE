//
//  User1.swift
//  SchoolE
//
//  Created by rentsl on 16/8/5.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation

struct User1 {
    var userName: String
    var userImage: String
    var password: String
    var userTel: String
    var school: String
    var studentID: String
    var name: String
    var payNumber: String
    
    init(
        userName: String,
        userImage: String,
        password: String,
        userTel: String,
        school: String,
        studentID: String,
        name: String,
        payNumber: String
    ) {
        self.name = name
        self.password = password
        self.payNumber = payNumber
        self.school = school
        self.studentID = studentID
        self.userImage = userImage
        self.userName = userName
        self.userTel = userTel
    }
    
}

