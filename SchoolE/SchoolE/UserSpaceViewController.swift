//
//  UserSpaceViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/3.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class UserSpaceViewController: UIViewController {

    var userLogin = LoginUser.sharedLoginUser
    
    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageB: UIButton!
    
    @IBAction func toLogin(sender: UIButton) {
        if userLogin.state == 0 {
            self.presentViewController((storyboard?.instantiateViewControllerWithIdentifier("signup"))!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let signout = UIAlertAction(title: "退出登录", style: .Default, handler: { (action) in
                self.userLogin.name = ""
                self.userLogin.password = ""
                self.userLogin.paynumber = ""
                self.userLogin.school = ""
                self.userLogin.state = 0
                self.userLogin.studentID = ""
                self.userLogin.userImage = UIImagePNGRepresentation(UIImage(named: "b004")!)
                self.userLogin.userName = "请登录"
                self.userLogin.userTel = ""
                self.userLogin._id = ""
                self.userLogin.authenticated = "0"
                self.userLogin.token = ""
                
                //写入文件的数据
                UserWriteToFile.writeToFile()
                
                self.userName.text = self.userLogin.userName
                self.userImageB.setImage(UIImage(data: self.userLogin.userImage!), forState: .Normal)
                
                //socket退登
                self.socketLogout()
            })
            let singuotCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            
            alert.addAction(signout)
            alert.addAction(singuotCancel)
            //ipad上必须加上
            /********************************/
            let x = userImageB.frame.origin.x + userImageB.frame.size.width/2
            let y = userImageB.frame.origin.y + userImageB.frame.size.height
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: x,y: y,width: 1.0,height: 1.0)
            /********************************/
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func toSetName(sender: UIButton) {
        if self.userLogin.state == 1 {
            self.presentViewController((storyboard?.instantiateViewControllerWithIdentifier("setName"))!, animated: true, completion: nil)
        }else{
            notice("请登录", type: NoticeType.info, autoClear: true, autoClearTime: 1)
        }
    }
    @IBAction func toSetTel(sender: UIButton) {
        if self.userLogin.state == 1 {
            self.presentViewController((storyboard?.instantiateViewControllerWithIdentifier("setTel"))!, animated: true, completion: nil)
        }else{
            notice("请登录", type: NoticeType.info, autoClear: true, autoClearTime: 1)
        }
    }
    @IBAction func toSetPayNumber(sender: UIButton) {
        if self.userLogin.state == 1 {
            self.presentViewController((storyboard?.instantiateViewControllerWithIdentifier("setPayNumber"))!, animated: true, completion: nil)
        }else{
            notice("请登录", type: NoticeType.info, autoClear: true, autoClearTime: 1)
        }
    }
    @IBAction func toSetSchool(sender: UIButton) {
        if self.userLogin.state == 1 {
            self.presentViewController((storyboard?.instantiateViewControllerWithIdentifier("setSchool"))!, animated: true, completion: nil)
        }else{
            notice("请登录", type: NoticeType.info, autoClear: true, autoClearTime: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取消按钮点击效果
        userImageB.adjustsImageWhenHighlighted = false
        //
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName:font
            ]
        }
        
        self.navigationController?.navigationBar.hideBottomHairline()
        
        ////关闭半透明
        //self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.barStyle = .Black
        //
        
        readView.backgroundColor = UIColor(red: 243/255, green: 135/255, blue: 138/255, alpha: 1)
        
        
        userImageB.setImage(UIImage(data: userLogin.userImage!), forState: .Normal)
        userName.text = userLogin.userName
        
    }

    override func viewDidAppear(animated: Bool) {
   
        userImageB.setImage(UIImage(data: userLogin.userImage!), forState: .Normal)
        userName.text = userLogin.userName
        
        if userLogin.state != 0 {
            
            //写入文件的数据
            UserWriteToFile.writeToFile()
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //socket退登
    func socketLogout(){
        SocketConnect.socket.once("logout") { data,ack in
            print("Socket Logout")
        }
        let items = ["method":"logout",
                     "_id":self.userLogin._id,
                     "token":self.userLogin.token]
        SocketConnect.socket.emit("logout", items)
    }
    
    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "setID" {
//            let destVC = segue.destinationViewController as! UserSettingViewController
//            destVC.user1 = self.user1
//        }
        
//        if segue.identifier == "setUser" {
//            let destVC = segue.destinationViewController as! IDSettingViewController
//            destVC.user1 = self.user1
//        }
//        
//        if segue.identifier == "setTel" {
//            let destVC = segue.destinationViewController as! TelSettingViewController
//            destVC.user1 = self.user1
//        }
//        
//        if segue.identifier == "setPayNumber" {
//            let destVC = segue.destinationViewController as! PaySettingViewController
//            destVC.user1 = self.user1
//        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func userSettingBack(_ : UIStoryboardSegue){
        
    }
    
    @IBAction func telSettingBack(_ : UIStoryboardSegue){
        
    }
    
    @IBAction func IDSettingBack(_ : UIStoryboardSegue){
        
    }
    
    @IBAction func paySettingBack(_ : UIStoryboardSegue){
        
    }
    
    @IBAction func signupBackToUserspeace(_ : UIStoryboardSegue){
    
    }
    
    @IBAction func userListBcak(_ : UIStoryboardSegue){
    
    }

}
