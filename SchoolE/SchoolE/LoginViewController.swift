//
//  LoginViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/10/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var userLogin = LoginUser.sharedLoginUser
    var user: [User] = []
    
    @IBOutlet weak var inputTel: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBAction func login(sender: UIButton) {
        
        if inputPassword.text == "" || inputTel.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            for p in user {
                if (p.userTel == self.inputTel.text && p.password == self.inputPassword.text) {
                    userLogin.name = p.name!
                    userLogin.userImage = p.userImage
                    userLogin.paynumber = p.paynumber!
                    userLogin.school = p.school!
                    userLogin.studentID = p.studentID!
                    userLogin.userTel = p.userTel!
                    userLogin.userName = p.userName!
                    userLogin.password = p.password!
                    userLogin.state = 1
                    
                    let dic: NSMutableDictionary = ["name":userLogin.name,"paynumber":userLogin.paynumber,"school":userLogin.school,"studentID":userLogin.studentID,"userTel":userLogin.userTel,"userName":userLogin.userName,"password":userLogin.password,"userImage":userLogin.userImage!]
                    
                    //创建文件
                    /*1******************************************/
                    var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
                    
                    if sp.count > 0 {
                        let url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
                    
                        dic.writeToFile(url.path!, atomically: true)
                        
//测试读取
//                                do{
//                                    if let data = try NSMutableDictionary(contentsOfURL: url)
//                        
//                                    {
//                                        print(data.allKeys)
//                                    }
//                        
//                                }catch let erro as NSError{
//                                    print("\(erro.localizedDescription)")
//                                }

                        
                    }
                    /*1******************************************/
                    
                    
                    
                }
            }
            
            
            
            if userLogin.state == 0 {
                notice("密码错误!", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            }else{
                performSegueWithIdentifier("signupBack", sender: sender)
            }
        
        }catch{
            print(error)
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


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signupBack(_:UIStoryboardSegue){}

}