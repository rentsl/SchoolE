//
//  LoginViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/10/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class LoginViewController: UIViewController {
    
    let signInSucceed       = "success"
    let signInPasswordError = "PASSWORD ERROR"
    let signInNotExist      = "NOT EXIST"
    var userLogin = LoginUser.sharedLoginUser
    var user: [User] = []
    let urlLogIn = MyURLs.urlLogIn
    let urlDownHeader = MyURLs.urlDownHeader
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var process: UIActivityIndicatorView!
    @IBOutlet weak var inputTel: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBAction func login(sender: UIButton) {
        
        if inputPassword.text == "" || inputTel.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        //正常的网络登录
        /*1****************************************************************************************/
        let userSignIn = ["data":["phone":self.inputTel.text!,"password":self.inputPassword.text!]]
        Alamofire.request(.POST, urlLogIn, parameters: userSignIn).responseJSON { Response in
            
            guard let json = Response.result.value as? NSDictionary else {return}
            
            if json.valueForKey("result") as! String == self.signInSucceed{
                print(json.valueForKey("result")!)
                self.process.startAnimating()
                //self.notice("登录成功", type: NoticeType.info, autoClear: true, autoClearTime: 1)
                print(Response)
                
                let jsonData = json.valueForKey("data") as? NSDictionary
                print(jsonData)
                
                //保存到用户单例
                self.userLogin._id = jsonData?.valueForKey("_id") as! String
                self.userLogin.authenticated = ((jsonData?.valueForKey("authenticated") as? NSNumber)?.stringValue)!
                self.userLogin.name = (jsonData?.valueForKey("real_name") != nil) ?
                    (jsonData?.valueForKey("real_name") as! String) : ""
                self.userLogin.password = jsonData?.valueForKey("password") as! String
                self.userLogin.paynumber = jsonData?.valueForKey("pay_number") as! String
                self.userLogin.school = jsonData?.valueForKey("school") as! String
                self.userLogin.studentID = jsonData?.valueForKey("student_id") as! String
                self.userLogin.token = jsonData?.valueForKey("token") as! String
                self.userLogin.userName = jsonData?.valueForKey("username") as! String
                self.userLogin.userTel = jsonData?.valueForKey("phone") as! String
                self.userLogin.state = 1
                
                //处理用户头像
                /**
                 *如果有就放入用户单例中
                 *没有就把单例中的userImage赋值“b004”
                 */
                if  jsonData?.valueForKey("avatar") as? String != "" {
                    //下载图片 Alamofire 3.5
                    let avatar = jsonData?.valueForKey("avatar") as! String
                    var isDowning = false
                    let imageURL = self.urlDownHeader + avatar
                    Alamofire.request(.GET, imageURL)
                        .responseData { responds in
                            guard let data = responds.result.value else {return}
                            
                            self.process.stopAnimating()
                            self.notice("登录成功", type: NoticeType.info, autoClear: true)
                            print("下载完成！")
                            
                            self.userLogin.userImage = data
                            //写入文件的数据
                            UserWriteToFile.writeToFile()
                            //转场
                            self.performSegueWithIdentifier("signupBack", sender: sender)
                        }
                        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                            let percent = totalBytesRead*100/totalBytesExpectedToRead
                            if isDowning == false {
                                //self.process.startAnimating()
                                print("hi")
                                isDowning = true
                            }
                            print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
                        }
                    
                }else{
                    self.userLogin.userImage = UIImagePNGRepresentation(UIImage(named:"b004")!)
                    //写入文件的数据
                    UserWriteToFile.writeToFile()
                    self.notice("登录成功", type: NoticeType.info, autoClear: true)
                    //转场
                    self.performSegueWithIdentifier("signupBack", sender: sender)
                }
                
                //socketLogin登陆
                self.socketLogin()
                
            }else if json.valueForKey("result") as! String == self.signInPasswordError{
                print(json.valueForKey("result")!)
                self.notice("密码错误", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            }else if json.valueForKey("result") as! String == self.signInNotExist{
                print(json.valueForKey("result")!)
                self.notice("用户不存在", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            }
            
        }
        /*1****************************************************************************************/
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIPinkColor
        //navigationBar自定义
        title = "账号设置"
        self.navigationController?.navigationBar.setWhiteStyle()
        
        process.hidesWhenStopped = true
        process.center = view.center
        view.addSubview(self.process)
        //process.startAnimating()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //socketLogin登陆
    func socketLogin(){
        guard userLogin._id != "" else {return}
        print("socketLogin")
        SocketConnect.socket.once("login") { data,ack in
            print("Socket Login Succeed!")
        }
        
        let items = ["method":"login",
                     "_id":self.userLogin._id,
                     "token":self.userLogin.token]
        SocketConnect.socket.emit("login", items)
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
