//
//  ChosePersonViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/11/18.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChosePersonViewController: UIViewController ,DownLoadImgeProtocol,ConfirmOrderProtocol,RefuseOrderProtocol{
    
    var orderLocal: OrderLocal!
    var receiverImageURL: String?
    var userLocal = LoginUser.sharedLoginUser
    let getImage = DownLoadImage()
    let refuseJudge = RefuseOrder()
    let comfireJudge = ConfirmOrder()
    let imageInit: NSData = UIImagePNGRepresentation(UIImage(named: "b004")!)!
    var present:UIViewController?
    
    @IBOutlet weak var personTel: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personRequestStatus: UILabel!
    @IBOutlet weak var comfireButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImage.delegate = self
        refuseJudge.delegate = self
        comfireJudge.delegate = self
        
        //UI自定义
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        self.navigationController?.navigationBar.setWhiteStyle()
        
        personName.text = ImageCash.receiverNAme[orderLocal.receiver]//?
        comfireButton.tintColor = UIPinkColor
        personImage.image = UIImage(data: imageInit)
        
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
            self.personTel.text = dataJson["data"]["phone"].string
            self.getImage.downLoadImageWithURLAndIndex(0, imageURL: dataJson["data"]["avatar"].string!,info: "")
            //缓存
            ImageCash.receiverNAme[receiverID] = dataJson["data"]["username"].string!
        }
        
        let items = ["method":"user info",
                     "_id":userLocal._id,
                     "data":[
                        "_id":receiverID]
                    ]
        SocketConnect.socket.emit("user info", items)
    }
    
    //监听"下载图片"事件
    func downImageListener(index: Int, imageData: NSData, info:String) {
        personImage.image = UIImage(data: imageData)
        imagecornerRadius(personImage)
        //必须将代理至为nil才能在dismissViewControllerAnimated的情况下执行deinit,释放内存
        getImage.delegate = nil
        
    }
    
    //监听是否拒绝成功
    func refuseSucceed(data: AnyObject) {
        (self.present as! OrderDetailViewController2).myOutOrders.status = "available"
        self.dismissViewControllerAnimated(true, completion: nil)
        refuseJudge.delegate = nil
    }
    
    //监听是否确认成功
    func comfirmSucceed(data: AnyObject) {
        (self.present as! OrderDetailViewController2).myOutOrders.status = "confirmed"
        self.dismissViewControllerAnimated(true, completion: nil)
        comfireJudge.delegate = nil
    }
    
    @IBAction func refuse(sender: UIButton) {
        guard userLocal._id != "" else {return}
       
        refuseJudge.refuseJudge(orderLocal.id)
    }
    
    
    @IBAction func accept(sender: UIButton) {
        guard userLocal._id != "" else {return}
        
        comfireJudge.comfirmJudge(orderLocal.id)
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
