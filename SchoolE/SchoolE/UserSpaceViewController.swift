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

    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: [User] = []
    var user1: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            
        }catch{
            print(error)
        }

        user1 = user[0]
        userImage.image = UIImage(data: user1.userImage!)
        userName.text = user1.userName
        
        //图片圆角
        imagecornerRadius(userImage)
        
    }

    override func viewDidAppear(animated: Bool) {
        
        //获取cocodata中User实体，放入user中
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "User")
        
        do{
            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
            
        }catch{
            print(error)
        }
        
        user1 = user[0]
        userImage.image = UIImage(data: user1.userImage!)
        userName.text = user1.userName
        
        //图片圆角
        imagecornerRadius(userImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func userSettingBack(segue: UIStoryboardSegue){
        
        
        
    }
    
    @IBAction func telSettingBack(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func IDSettingBack(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func paySettingBack(segue: UIStoryboardSegue){
        
    }

}
