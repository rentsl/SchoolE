//
//  UserSettingViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/8/4.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import Alamofire

class UserSettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UpdateProfileProtocol {

    var userLogin = LoginUser.sharedLoginUser
    var user: [User] = []
    let urlUpLoadAvatar = MyURLs.urlUpLoadAvatar
    let updateProfile = UpdateProfile()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
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
        
        //修改userName
        
        updateProfile.updateUserName(inputUserName.text!)
        
        //修改用户单例
        userLogin.userImage = UIImagePNGRepresentation(userImage.image!)
        
        
        notice("修改成功", type: NoticeType.success, autoClear: true, autoClearTime: 1)
        
        //退场
        performSegueWithIdentifier("IDBack", sender: sender)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfile.delegate = self
        
        //navigationBar自定义
        title = "账号设置"
        self.navigationController?.navigationBar.setWhiteStyle()
        
        //组件赋初值
        
        userImage.image = UIImage(data: userLogin.userImage!)
        inputUserName.text = userLogin.userName
        userImage.frame.size.width = 60.0
        userImage.frame.size.height = 60.0
        
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
        userImage.frame.size.width = 60.0
        userImage.frame.size.height = 60.0
        
        //图片圆角
        //imagecornerRadius(userImage)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    //监听修改昵称成功
    func userNameBeUpdated() {
        userLogin.userName = inputUserName.text!
        //退场
        notice("修改成功", type: NoticeType.success, autoClear: true, autoClearTime: 1)
        performSegueWithIdentifier("IDBack", sender: saveButton)
        updateProfile.delegate = nil
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
