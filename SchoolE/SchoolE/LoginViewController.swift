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
        Alamofire.request(.POST, "http://121.42.186.184:3000/login", parameters: userSignIn).responseJSON { Response in
            
            guard let json = Response.result.value as? NSDictionary else {return}
            
            if json.valueForKey("result") as! String == self.signInSucceed{
                print(json.valueForKey("result")!)
                self.process.startAnimating()
                //self.notice("登录成功", type: NoticeType.info, autoClear: true, autoClearTime: 1)
                print(Response)
                
                let jsonData = json.valueForKey("data") as? NSDictionary
                
                //保存到用户单例
                self.userLogin._id = jsonData?.valueForKey("_id") as! String
                self.userLogin.authenticated = ((jsonData?.valueForKey("authenticated") as? NSNumber)?.stringValue)!
                self.userLogin.name = "" // 需要添加 服务器端还没
                self.userLogin.password = jsonData?.valueForKey("password") as! String
                self.userLogin.paynumber = jsonData?.valueForKey("pay_number") as! String
                self.userLogin.school = jsonData?.valueForKey("school") as! String
                self.userLogin.studentID = jsonData?.valueForKey("student_id") as! String
                self.userLogin.token = jsonData?.valueForKey("token") as! String
                self.userLogin.userName = ((jsonData?.valueForKey("phone") as? NSNumber)?.stringValue)!
                self.userLogin.userTel = ((jsonData?.valueForKey("phone") as? NSNumber)?.stringValue)!
                self.userLogin.state = 1
                
                //处理用户头像
                /**
                 *如果有就放入用户单例中
                 *没有就把单例中的userImage赋值“b004”
                 */
                if let avatar = jsonData?.valueForKey("avatar") as? String{
                    //下载图片 Alamofire 3.5
                    var isDowning = false
                    let imageURL = "http://121.42.186.184:3000/images/" + avatar
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
                
                
                
                
            }else if json.valueForKey("result") as! String == self.signInPasswordError{
                print(json.valueForKey("result")!)
                self.notice("密码错误", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            }else if json.valueForKey("result") as! String == self.signInNotExist{
                print(json.valueForKey("result")!)
                self.notice("用户不存在", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            }
            
            
            //self.performSegueWithIdentifier("signupBack", sender: sender)
        }
        /*1****************************************************************************************/
        
        
        //利用本地数据库中的内容进行登录
        /*2****************************************************************************************/
        
//        //获取cocodata中User实体，放入user中
//        
//        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
//        let userRequest = NSFetchRequest(entityName: "User")
//        
//        do{
//            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
//            for p in user {
//                if (p.userTel == self.inputTel.text && p.password == self.inputPassword.text) {
//                    userLogin.name = p.name!
//                    userLogin.userImage = p.userImage
//                    userLogin.paynumber = p.paynumber!
//                    userLogin.school = p.school!
//                    userLogin.studentID = p.studentID!
//                    userLogin.userTel = p.userTel!
//                    userLogin.userName = p.userName!
//                    userLogin.password = p.password!
//                    userLogin.state = 1
//                    
//                    let dic: NSMutableDictionary = ["name":userLogin.name,"paynumber":userLogin.paynumber,"school":userLogin.school,"studentID":userLogin.studentID,"userTel":userLogin.userTel,"userName":userLogin.userName,"password":userLogin.password,"userImage":userLogin.userImage!]
//                    
//                    //创建文件
//                    /*3******************************************/
//                    var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
//                    
//                    if sp.count > 0 {
//                        let url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
//                    
//                        dic.writeToFile(url.path!, atomically: true)
//                        
//                    }
//                    /*3******************************************/
//          
//                }
//            }
//            
//            if userLogin.state == 0 {
//                notice("密码错误!", type: NoticeType.info, autoClear: true, autoClearTime: 2)
//            }else{
//                performSegueWithIdentifier("signupBack", sender: sender)
//            }
//        
//        }catch{
//            print(error)
//        }
        /*2****************************************************************************************/
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
