//
//  updataProfile.swift
//  SchoolE
//
//  Created by rentsl on 16/11/26.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol UpdateProfileProtocol:NSObjectProtocol {
    optional func userNameBeUpdated()
    optional func schoolBeUpdated()
    optional func nameBeUpdated()
    optional func schoolIDUpdated()
}

class UpdateProfile{
    
    var userLogin = LoginUser.sharedLoginUser
    var delegate: UpdateProfileProtocol?
    
    func updateUserName(newUserName:String){
        let data = [
            "data":[
                "_id":userLogin._id,
                "token":userLogin.token,
                "username":newUserName
            ]
        ]
        Alamofire.request(.POST,MyURLs.urlUpdateProfire,parameters: data).responseJSON { Response
            in
            guard let json = Response.result.value as? NSDictionary else {return}
            guard (json.valueForKey("result") as! String) == _success else {return}
            print("修改昵称成功")
            self.delegate?.userNameBeUpdated!()
        }
    }
    
    func updateSchool(newSchool:String){
        let data = [
            "data":[
                "_id":userLogin._id,
                "token":userLogin.token,
                "school":newSchool
            ]
        ]
        Alamofire.request(.POST,MyURLs.urlUpdateProfire,parameters: data).responseJSON { Response
            in
            guard let json = Response.result.value as? NSDictionary else {return}
            guard (json.valueForKey("result") as! String) == _success else {return}
            print("修改学校成功")
            self.delegate?.schoolBeUpdated!()
        }
    }
    
    func updateName(newName:String){
        let data = [
            "data":[
                "_id":userLogin._id,
                "token":userLogin.token,
                "real_name":newName
            ]
        ]
        Alamofire.request(.POST,MyURLs.urlUpdateProfire,parameters: data).responseJSON { Response
            in
            guard let json = Response.result.value as? NSDictionary else {return}
            guard (json.valueForKey("result") as! String) == _success else {return}
            print("修改姓名成功")
            self.delegate?.nameBeUpdated!()
        }
    }
    
    func updateSchoolID(newSchoolID:String){
        let data = [
            "data":[
                "_id":userLogin._id,
                "token":userLogin.token,
                "student_id":newSchoolID
            ]
        ]
        Alamofire.request(.POST,MyURLs.urlUpdateProfire,parameters: data).responseJSON { Response
            in
            guard let json = Response.result.value as? NSDictionary else {return}
            guard (json.valueForKey("result") as! String) == _success else {return}
            print("修改学号成功")
            self.delegate?.schoolIDUpdated!()
        }
    }
    
}
