//
//  OrderDetailViewController2.swift
//  SchoolE
//
//  Created by rentsl on 16/9/3.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class OrderDetailViewController2: UIViewController {

    //var order: Order!
    var index = 0
    var selectRow: NSIndexPath?
    var myOutOrders: OrderLocal!
    var isDel: Bool?
    var userLocal = LoginUser.sharedLoginUser
    
    
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var orderState: UIButton!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBAction func orderStatusButton(sender: UIButton) {
        guard myOutOrders.status == "grabbed" else {return}
        
        let nib = storyboard?.instantiateViewControllerWithIdentifier("ChosePerson")
        presentViewController(nib!, animated: true, completion: nil)
        (nib?.childViewControllers[0] as? ChosePersonViewController)?.orderLocal = myOutOrders
        (nib?.childViewControllers[0] as? ChosePersonViewController)?.present = self
        //print(myOutOrders.receiver)
        //print(myOutOrders.cost)
    }
    @IBAction func delOrderButton(sender: UIButton) {
        
        switch myOutOrders.status {
        case "confirmed":
            SocketConnect.socket.once("order finish") { data,ack in
                self.performSegueWithIdentifier("toOrder2", sender: sender)
            }
            finshOrderRequest()
        case "available","grabbed":
            SocketConnect.socket.once("order cancel") { data,ack in
                print(data)
                self.performSegueWithIdentifier("toOrder2", sender: sender)
            }
            delOrderRequest()
        default:
            notice("错误", type: NoticeType.error, autoClear: true, autoClearTime: 1)
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //isDel = false
        
        
        
        userImage.image = UIImage(data: userLocal.userImage!)
        userName.text = myOutOrders.publisherName
        location.text = myOutOrders.location
        detail.text = myOutOrders.detail
        orderState.setTitle(statusToState(myOutOrders.status), forState: .Normal)
        money.text = myOutOrders.cost
        tel.text = myOutOrders.publisherTel
        time.text = myOutOrders.time
            
        //确认图片大小
        userImage.frame.size.width = 50.0
        userImage.frame.size.height = 50.0
    
        //图片圆角
        imagecornerRadius(userImage)
            
        buttonSetImage(delButton)
        
        //上色
        orderState.setTitleColor( stateColor(statusToState(myOutOrders.status)), forState: .Normal)
        

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear:\(myOutOrders.status)")
        orderState.setTitle(statusToState(myOutOrders.status), forState: .Normal)
        //上色
        orderState.setTitleColor( stateColor(statusToState(myOutOrders.status)), forState: .Normal)
        buttonSetImage(delButton)
    }
    
    deinit{
        print("OrderDetailViewController2 deinit")
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
            state = "有人抢单"
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
    
    //设置大圆按钮的图片
    func buttonSetImage(button:UIButton){
        print("buttonSetImage")
        if (myOutOrders.status == "confirmed") {
            button.setImage(UIImage(named: "shou"), forState: .Normal)
            button.setImage(UIImage(named: "shouBg"), forState: .Highlighted)
            button.setImage(UIImage(named: "shouBg"), forState: .Selected)
        }else{
            button.setImage(UIImage(named: "che"), forState: .Normal)
            button.setImage(UIImage(named: "cheBg"), forState: .Highlighted)
            button.setImage(UIImage(named: "cheBg"), forState: .Selected)
        }
    }
    
    //删除订单请求
    func delOrderRequest(){
        guard userLocal._id != "" else {return}
        let items = ["method":"order cancel",
                     "_id":userLocal._id,
                     "token":userLocal.token,
                     "orderId":myOutOrders.id]
        SocketConnect.socket.emit("order cancel", items)
    }
    
    //完成订单请求
    func finshOrderRequest(){
        guard userLocal._id != "" else {return}
        let items = ["method":"order finish",
                     "_id":userLocal._id,
                     "token":userLocal.token,
                     "orderId":myOutOrders.id]
        SocketConnect.socket.emit("order finish", items)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toChosePerson"{
//        
//            let destVC = segue.destinationViewController as! ChosePersonViewController
//            
//            destVC.orderLocal = myOutOrders
//        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func backToDetail2(_ :UIStoryboardSegue){
        
    }

}
