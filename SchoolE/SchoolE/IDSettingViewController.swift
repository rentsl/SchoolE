//
//  IDSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class IDSettingViewController: UIViewController {

    @IBOutlet weak var inputSchool: UITextField!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputStudentID: UITextField!
    @IBAction func save(sender: UIBarButtonItem) {
        
        if inputName.text == "" || inputStudentID.text == "" || inputSchool.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        
        //查并修改（根据手机号来查）
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            //print(user.count)
            for user0 in user {
                if user0.userTel == user1.userTel {
                    //print("hi")
                    user0.school = inputSchool.text
                    user0.name = inputName.text
                    user0.studentID = inputStudentID.text
                    
                }
            }
            
        }catch{
            print(error)
        }
        
        //保存修改
        do {
            try  buffer?.save()
        } catch {
            print(error)
        }
        
        notice("修改成功", type: NoticeType.success, autoClear: true, autoClearTime: 1)
        
        //退场
        performSegueWithIdentifier("userBack", sender: sender)
        
    }
    
    var user: [User] = []
    var user1: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationBar自定义
        title = "身份设置"
        self.navigationController?.navigationBar.hideBottomHairline()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1),
                NSFontAttributeName:font
            ]
        }
        
        self.navigationController?.navigationBar.barStyle = .Default
        
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            
        }catch{
            print(error)
        }
        user1 = user[0]
        
        //组件赋初值
        
        inputSchool.text = user1.school
        inputName.text = user1.name
        inputStudentID.text = user1.studentID
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
