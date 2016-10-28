//
//  SignupViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/10/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {

    var user: [User] = []
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func confiemPassword(sender: UIButton) {
        
        if (tel.text == nil || password.text == nil || confirmPassword.text == nil || confirmPassword.text != password.text){
            notice("输入错误！", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            return
        }
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: buffer!) as! User
        
        user.name = tel.text
        user.password = password.text
        user.paynumber = ""
        user.school = ""
        user.studentID = ""
        user.userImage = UIImagePNGRepresentation(UIImage(named: "b004")!)
        user.userName = tel.text
        user.userTel = tel.text
        
        do{
            try buffer?.save()
        }catch{
            print("用户存储失败！")
            print(error)
        }
        //退场
        performSegueWithIdentifier("backToSignIn", sender: sender)
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
