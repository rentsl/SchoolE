//
//  TelSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

//////////////////////////////////////////
//                                      //
//                                      //
//                                      //
//                 作废                  //
//                                      //
//                                      //
//                                      //
//////////////////////////////////////////

class TelSettingViewController: UIViewController {

    var userLogin = LoginUser.sharedLoginUser
    
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputTel: UITextField!
    @IBAction func save(sender: UIBarButtonItem) {
        
        if inputPassword.text == "" || inputTel.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        if passwordTest() {
            
            
            //获取cocodata中User实体，放入user中
            
            let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
            let userRequest = NSFetchRequest(entityName: "User")
            
            
            //查并修改（根据手机号来查）
            do{
                self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
                //print(user.count)
                for user0 in user {
                    if user0.userTel == userLogin.userTel {
                        user0.userTel = inputTel.text
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
            
            //保存到用户单例
            userLogin.userTel = inputTel.text!
            
            notice("修改成功", type: NoticeType.success, autoClear: true, autoClearTime: 1)
 
            //退场
            performSegueWithIdentifier("TelBack", sender: sender)
            
        }else {
            notice("密码错误", type: .error, autoClear: true, autoClearTime: 2)
        }

    }
    
    var user: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar自定义
        title = "手机设置"
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
        
        //组件赋初值
        
        inputTel.text = userLogin.userTel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //判断密码是否正确
    
    func passwordTest() -> Bool {
        
        if self.userLogin.password == inputPassword.text {
            return true
        }
        
        return false
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
