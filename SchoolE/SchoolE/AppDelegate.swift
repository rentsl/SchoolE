//
//  AppDelegate.swift
//  FoodPin
//
//  Created by xiaobo on 15/10/5.
//  Copyright © 2015年 xiaobo. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SocketIO
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    let signInTokenSucceed       = "success"
    let signInTokenPasswordError = "TOKEN ERROR"
    let signInTokenNotExist      = "ID NOT EXIST"
    
    var window: UIWindow?
    var userLogin = LoginUser.sharedLoginUser
    var user: [User] = []
    var user1: User!
    let urlTokenLogin = MyURLs.urlTokenLogin

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print("application")
        SocketConnect.socketConnect()
        
        UINavigationBar.appearance().barTintColor = UIPinkColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName:font
            ]
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        UITabBar.appearance().tintColor = UIPinkColor
        
        
        
        //读取文件中的用户信息
        var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        
        if sp.count > 0 {
            let url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
            print("文件路径:\(url)")
            if let data = NSMutableDictionary(contentsOfURL: url){
                print("读取文件！")
                
                let tokenAndId = ["data":["_id":data.objectForKey("_id") as! String,"token":data.objectForKey("token") as! String]]
                

                Alamofire.request(.POST, urlTokenLogin,parameters: tokenAndId).responseJSON{ Response in
                    guard let json = Response.result.value as? NSDictionary else {return}
                    if json.valueForKey("result") as! String == self.signInTokenSucceed {
                        print("token登录成功！")
                        
                        
                        
                        if let jsonData = json.valueForKey("data") as? NSDictionary {
                            
                            print(jsonData)
                            
                            //保存到用户单例
                            self.userLogin._id = jsonData.valueForKey("_id") as! String
                            self.userLogin.authenticated = ((jsonData.valueForKey("authenticated") as? NSNumber)?.stringValue)!
                            self.userLogin.name = jsonData.valueForKey("real_name") as! String
                            self.userLogin.password = jsonData.valueForKey("password") as! String
                            self.userLogin.paynumber = jsonData.valueForKey("pay_number") as! String
                            self.userLogin.school = jsonData.valueForKey("school") as! String
                            self.userLogin.studentID = jsonData.valueForKey("student_id") as! String
                            self.userLogin.token = jsonData.valueForKey("token") as! String
                            self.userLogin.userName = jsonData.valueForKey("username") as! String
                            self.userLogin.userTel = jsonData.valueForKey("phone") as! String
                            self.userLogin.state = 1
                            
                            //处理用户头像
                            /**
                             *如果有就放入用户单例中
                             *没有就把单例中的userImage赋值“b004”
                             */
                            
                            if let fUserimage = data.objectForKey("userImage") {
                                print("获取文件中的图片")
                                self.userLogin.userImage = fUserimage as? NSData
                            }else{
                                self.userLogin.userImage = UIImagePNGRepresentation(UIImage(named:"b004")!)
                            }
                            
                            //等待token登陆和Socket连上后进行socketlogin
                            SocketConnect.socket.once("connect") {_,_ in self.socketLogin()}
                            
                        }
                        
                    }else if json.valueForKey("result") as! String == self.signInTokenPasswordError {
                        print("token错误")
                        
                        let alert = UIAlertController(title: "账号过期", message: "请重新登陆", preferredStyle: .Alert)
                        let comfirm = UIAlertAction(title: "确定", style: .Default, handler: nil)
                        alert.addAction(comfirm)
                        
                        let aW = UIWindow(frame: UIScreen.mainScreen().bounds)
                        aW.rootViewController = UIViewController()
                        aW.windowLevel = UIWindowLevelAlert + 1
                        aW.makeKeyAndVisible()
                        aW.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                        
                    }else if json.valueForKey("result") as! String == self.signInTokenNotExist {
                        print("ID不存在！")
                    }
                    
                }
                
            }
            
        }
        print(userLogin.state)
        
//        //wesocket测试
//        
//        SocketConnect.socketConnect()

        
        //网络测试
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json",forKey: "Content-Type")
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json",forKey: "Accept")
        
        

        
//        let user = ["data":["phone":"123","password":"123"]]
//
//        Alamofire.request(.POST,"http://121.42.186.184:3000/login",parameters: user).responseJSON { Response
//            in
//            
//            guard let json = Response.result.value as? NSDictionary else {return}
//            
//            print(json)
//            
//            print(json.valueForKey("data")?.valueForKey("password") as! String)
//        }
        
          //上传图片
        
//        Alamofire.upload(.POST, "http://121.42.186.184:3000/file/upload", multipartFormData: { MultipartFormData
//            in
//            let time = SystemTime.sharedTime.getNoBlankTime()
//            let uploadImage = UIImage(named: "b004")
//            let data = UIImageJPEGRepresentation(uploadImage!,1)
//            let imageName = String(time) + ".png"
//            
//            MultipartFormData.appendBodyPart(data: data!, name: "displayImage", fileName: imageName, mimeType: "image/png")
//        }) { encodingResult in
//            switch encodingResult {
//            case .Success(let upload, _, _):
//                upload.responseJSON(completionHandler: { (response) in
//                        print(response)
//                })
//            case .Failure(let encodingError):
//                print(encodingError)
//            }
//        }
        
//        //获取cocodata中User实体，放入user中
//        
//        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
//        let userRequest = NSFetchRequest(entityName: "User")
//        
//        do{
//            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
//            
//        }catch{
//            print(error)
//        }
//        
//        user1 = user[0]
//        //放入单例中
//        userLogin.name = user1.name!
//        userLogin.userImage = user1.userImage
//        userLogin.paynumber = user1.paynumber!
//        userLogin.school = user1.school!
//        userLogin.studentID = user1.studentID!
//        userLogin.userTel = user1.userTel!
//        userLogin.userName = user1.userName!
//        userLogin.password = user1.password!
//        userLogin.state = 1
   
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        //从后台回来时 进行socketlogin
        SocketConnect.socket.once("connect") {_,_ in self.socketLogin()}
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //写入文件的数据
        UserWriteToFile.writeToFile()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xiaoboswift.coredataDemo1" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SchoolE", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SchoolE.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
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
    

}

