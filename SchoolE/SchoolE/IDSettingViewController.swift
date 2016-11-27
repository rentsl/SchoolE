//
//  IDSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class IDSettingViewController: UIViewController,UpdateProfileProtocol {

    var userLogin = LoginUser.sharedLoginUser
    let updateProfile = UpdateProfile()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var inputSchool: UITextField!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputStudentID: UITextField!
    @IBAction func save(sender: UIBarButtonItem) {
        
        if inputName.text == "" || inputStudentID.text == "" || inputSchool.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        //发送修改内容
        updateProfile.updateSchool(inputSchool.text!)
        updateProfile.updateSchoolID(inputStudentID.text!)
        updateProfile.updateName(inputName.text!)
        
    }
    
    var user: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateProfile.delegate = self
        
        //navigationBar自定义
        title = "身份设置"
        self.navigationController?.navigationBar.setWhiteStyle()
        
        //组件赋初值
        inputSchool.text = (userLogin.school != "") ? userLogin.school : "杭州电子科技大学"
        inputName.text = userLogin.name
        inputStudentID.text = userLogin.studentID
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:监听修改成功事件
    
    func schoolIDUpdated() {
        userLogin.studentID = inputStudentID.text!
    }
    
    func schoolBeUpdated() {
        userLogin.school = inputSchool.text!
    }

    func nameBeUpdated() {
        userLogin.name = inputName.text!
        notice("修改成功", type: NoticeType.success, autoClear: true, autoClearTime: 1)
        //退场
        performSegueWithIdentifier("userBack", sender: saveButton)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
