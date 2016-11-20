//
//  OrderDetailViewController3.swift
//  SchoolE
//
//  Created by rentsl on 16/9/9.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class OrderDetailViewController3: UIViewController ,DownLoadImgeProtocol{

    var myGetOrder: OrderLocal!
    var selectRow: NSIndexPath?
    var isDel: Bool?
    var imageURL: String!
    var index = 0
    var userLocal = LoginUser.sharedLoginUser
    var imageCash: NSData?
    
    let getImage = DownLoadImage()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var delButton: UIButton!
    @IBAction func delAction(sender: UIButton) {
        notice("你没有权限", type: NoticeType.error, autoClear: true, autoClearTime: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImage.delegate = self
        
        
        if ((ImageCash.myGetActiveOrderImage[myGetOrder.publisherID]) != nil) {
            userImage.image = UIImage(data: ImageCash.myGetActiveOrderImage[myGetOrder.publisherID]!)
        }else{
            getImage.downLoadImageWithURLAndIndex(0, imageURL: (MyURLs.urlDownHeader + imageURL),info: "")
            userImage.image = UIImage(data: myGetOrder.publisherImage!)
        }
        userName.text = myGetOrder.publisherName
        location.text = myGetOrder.location
        detail.text = myGetOrder.detail
        orderState.text = statusToState(myGetOrder.status)
        money.text = myGetOrder.cost
        tel.text = myGetOrder.publisherTel
        time.text = myGetOrder.time
        
        //确认图片大小
        userImage.frame.size.width = 50.0
        userImage.frame.size.height = 50.0
    
        //图片圆角
        imagecornerRadius(userImage)
        
        if myGetOrder.publisherName  == "Rentsl" && myGetOrder.status != "已完成" {
            delButton.setImage(UIImage(named: "che"), forState: .Normal)
            delButton.setImage(UIImage(named: "cheBg"), forState: .Highlighted)
            delButton.setImage(UIImage(named: "cheBg"), forState: .Selected)
        }
        
        orderState.textColor = stateColor(statusToState(myGetOrder.status))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //状态着色
    func stateColor(state: String) -> UIColor {
        var color: UIColor
        switch state {
        case "等人抢单":
            color = UIColor(red: 153/225, green: 204/225, blue: 51/225, alpha: 1)
        case "有人抢单":
            color = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        case "正在进行":
            color = UIColor(red: 102/225, green: 204/225, blue: 204/225, alpha: 1)
        case "已完成":
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        case "等待确认":
            color = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        case "已取消":
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        default:
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        }
        return color
    }
    
    //状态转换 服务端->客户端
    func statusToState(status:String) -> String{
        var state:String
        switch status {
        case "available":
            state = "等人抢单"
        case "grabbed":
            state = "等待确认"
        case "confirmed":
            state = "正在进行"
        case "onRoad":
            state = "正在进行"
        case "reached":
            state = "正在进行"
        case "finished":
            state = "已完成"
        case "cancelled":
            state = "已取消"
        case "error":
            state = "点单错误"
        default:
            state = "等人抢单"
        }
        return state
    }

    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2

        image.clipsToBounds = true
    }
    
    //监听下载图片事件
    func getDownImage(index: Int, imageData: NSData,info: String) {
        self.userImage.image = UIImage(data: imageData)
        //缓存
        ImageCash.myGetActiveOrderImage[self.myGetOrder.publisherID] = imageData
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
