//
//  UserSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class UserSettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: [User] = []
    var user1: User!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var inputUserName: UITextField!
    @IBAction func choseImage(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func save(sender: UIBarButtonItem) {
        
        if inputUserName == ""{
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
                    user0.userImage = UIImagePNGRepresentation(userImage.image!)
                    user0.userName = inputUserName.text
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
        performSegueWithIdentifier("IDBack", sender: sender)
        
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
        
        userImage.image = UIImage(data: user1.userImage!)
        inputUserName.text = user1.userName
        userImage.frame = CGRectMake(0.0, 0.0, 60.0, 60.0)
        
        //图片圆角
        imagecornerRadius(userImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        userImage.image = image
        userImage.frame = CGRectMake(0.0, 0.0, 60.0, 60.0)
        
        //图片圆角
        //imagecornerRadius(userImage)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
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
