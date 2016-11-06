//
//  SignupViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/10/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SignupViewController: UIViewController {

    let signUpSucceed = "register success"
    let signUpFaild = "ALREADY EXIST"
    
    var user: [User] = []
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func confiemPassword(sender: UIButton) {
        
        if (tel.text == "" || password.text == "" || confirmPassword.text == "" || confirmPassword.text != password.text){
            notice("输入错误！", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            return
        }
        
        
        
//        /reg        注册
//        请求:{
//            phone: number
//            password: String
//            ^username: String
//            ^authenticated: Boolean
//            ^school: String
//            ^address: String
//        }
//        回复:{
//            result: string
//            register success    注册成功
//            ALREADY EXIST       手机号已存在
//        }
        
        let signUpUser = ["data":["phone":tel.text!,"password":password.text!,"username":"","authenticated":false,"school":"","address":"","student_id":"","pay_number":""]]
        
        Alamofire.request(.POST,"http://121.42.186.184:3000/reg",parameters: signUpUser).responseJSON { Response
            in
            guard let json = Response.result.value as? NSDictionary else {
                self.notice("注册失败！", type: NoticeType.info, autoClear: true, autoClearTime: 1)
                return
            }
            //收到response后的操作
            
            if json.valueForKey("result") as! String == self.signUpSucceed {
                print(json.valueForKey("result")!)
                self.notice("注册成功", type: NoticeType.info, autoClear: true, autoClearTime: 1)
                
                //将用户信息放入本地数据库
                let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
                let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: buffer!) as! User
                
                user.name = self.tel.text
                user.password = self.password.text
                user.paynumber = ""
                user.school = ""
                user.studentID = ""
                user.userImage = UIImagePNGRepresentation(UIImage(named: "b004")!)
                user.userName = self.tel.text
                user.userTel = self.tel.text
                
                do{
                    try buffer?.save()
                }catch{
                    print("用户信息本地存储失败！")
                    print(error)
                }
                
            }else{
                print(json.valueForKey("result")!)
                self.notice("该用户已存在", type: NoticeType.info, autoClear: true, autoClearTime: 1)
                return
            }
                
            //退场
            self.performSegueWithIdentifier("backToSignIn", sender: sender)
                
        }
       
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar自定义
        title = "账号设置"
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
        
        //得到user列表
        user = getUserData()
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData() -> [User]{
        //获取cocodata中User实体，放入user中
        var user: [User] = []
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        do {
            user = try buffer!.executeFetchRequest(userRequest) as! [User]
        }catch{
            print("获取User表数据失败！")
            print(error)
        }
        return user
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
