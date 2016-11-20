//
//  UserSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class UserSettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userLogin = LoginUser.sharedLoginUser
    var user: [User] = []
    let urlUpLoadAvatar = MyURLs.urlUpLoadAvatar
    
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
        
        
        //网络存储
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        
        //上传图片
        
        Alamofire.upload(.POST, urlUpLoadAvatar, multipartFormData: { MultipartFormData
            in
            let time = SystemTime.sharedTime.getNoBlankTime()
            let uploadImage = self.userImage.image
            let data = UIImageJPEGRepresentation(uploadImage!,1)
            //let iD = NSData(base64EncodedString: "hi", options: NSDataBase64DecodingOptions(rawValue: NSUTF8StringEncoding))
            let imageName = String(time) + ".png"
        
            MultipartFormData.appendBodyPart(data: data!, name: "image",fileName: imageName, mimeType: "image/png")
            MultipartFormData.appendBodyPart(data:self.userLogin._id.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "_id")
            MultipartFormData.appendBodyPart(data: "png".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "extension")
            
        }) { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                        print(response)
                    print("succeed")
                })
            case .Failure(let encodingError):
                print(encodingError)
                print("error")
            }
        }

        
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        
        
        //本地数据库存储
        /*-----------------------------------------------------------*/
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        
        //查并修改（根据手机号来查）
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            //print(user.count)
            for user0 in user {
                if user0.userTel == userLogin.userTel {
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
        /*-----------------------------------------------------------*/
        
        //修改用户单例
        userLogin.userImage = UIImagePNGRepresentation(userImage.image!)
        userLogin.userName = inputUserName.text!
        
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
        
        //组件赋初值
        
        userImage.image = UIImage(data: userLogin.userImage!)
        inputUserName.text = userLogin.userName
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
        
        let smallImage = UIImageJPEGRepresentation(image, 0.3)
        userImage.image = UIImage(data: smallImage!)
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
