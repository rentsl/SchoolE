//
//  ChosePersonViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChosePersonViewController: UIViewController ,DownLoadImgeProtocol{
    
    var orderLocal: OrderLocal!
    var receiverImageURL: String?
    var userLocal = LoginUser.sharedLoginUser
    let getImage = DownLoadImage()
    //let imageInit: NSData = UIImagePNGRepresentation(UIImage(named: "b004")!)!
    var present:UIViewController?
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personRequestStatus: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI自定义
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
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
        
        if let image = ImageCash.receiverImage[orderLocal.receiver]{
            getImage.delegate = nil //假如已经有缓存了,那就不用网络请求了,那也就不用挂代理了,也方便点"取消"时会调用deinit,释放内存
            personImage.image = UIImage(data: image)
            personName.text = ImageCash.receiverNAme[orderLocal.receiver]
        }else{
            getImage.delegate = self
        }
        
        personImage.frame.size.width = 128.0
        personImage.frame.size.height = 128.0
        imagecornerRadius(personImage)
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        
        
        //获取receiver信息
        getReceiverInfo(orderLocal.receiver)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit{
        print("ChosePersonViewController deinit")
    }
    
    
    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    
    //网络获取receiver的信息
    func getReceiverInfo(receiverID: String){
        guard (ImageCash.receiverImage[receiverID] == nil) else {return}
        
        SocketConnect.socket.once("user info") { data,ack in
            //将data转成JSON格式
            let dataString = String((data as NSArray)[0])
            let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let dataJson = JSON(data:jsonData!)
            //print(dataJson)
            
            self.personName.text = dataJson["data"]["username"].string
            self.getImage.downLoadImageWithURLAndIndex(0, imageURL: (MyURLs.urlDownHeader + dataJson["data"]["avatar"].string!),info: "")
            //缓存
            ImageCash.receiverNAme[receiverID] = dataJson["data"]["username"].string!
        }
        
        let items = ["method":"user info",
                     "_id":userLocal._id,
                     "data":[
                        "_id":receiverID
                    ]]
        SocketConnect.socket.emit("user info", items)
    }
    
    //监听"下载图片"事件
    func getDownImage(index: Int, imageData: NSData, info:String) {
        personImage.image = UIImage(data: imageData)
        imagecornerRadius(personImage)
        //缓存
        ImageCash.receiverImage[self.orderLocal.receiver] = imageData
        //print(getImage.delegate)
        //必须将代理至为nil才能在dismissViewControllerAnimated的情况下执行deinit,释放内存
        getImage.delegate = nil
        
    }
    
    @IBAction func refuse(sender: UIButton) {
        guard userLocal._id != "" else {return}
       
        //监听
        SocketConnect.socket.once("order refuse") { data,ack in
            //print(data)
            (self.present as! OrderDetailViewController2).myOutOrders.status = "available"
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //请求
        let items = ["method":"order refuse",
                     "_id":userLocal._id,
                     "token":userLocal.token,
                     "orderId":orderLocal.id]
        SocketConnect.socket.emit("order refuse", items)
    }
    
    
    @IBAction func accept(sender: UIButton) {
        guard userLocal._id != "" else {return}
        
//        (self.present as! OrderDetailViewController2).myOutOrders.status = "confirmed"
//        self.dismissViewControllerAnimated(true) {}
        //监听
        SocketConnect.socket.once("order confirm") { data,ack in
            //print(data)
            (self.present as! OrderDetailViewController2).myOutOrders.status = "confirmed"
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //请求
        let items = ["method":"order confirm",
                     "_id":userLocal._id,
                     "token":userLocal.token,
                     "orderId":orderLocal.id]
        SocketConnect.socket.emit("order confirm", items)
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
