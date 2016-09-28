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
    var myGetOrders: Order1!
    var myOutOrders: Order!
    var isDel: Bool?
    
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBAction func delOrder(sender: UIButton) {
        if index == 1{
            isDel = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isDel = false
        
        print("bn\(index)")
        if index == 0{
            userImage.image = UIImage(named: myGetOrders.userImage)
            userName.text = myGetOrders.userName
            location.text = myGetOrders.location
            detail.text = myGetOrders.detail
            orderState.text = myGetOrders.orderState
            money.text = myGetOrders.money
            tel.text = myGetOrders.userTel
            time.text = myGetOrders.time
            
            //图片圆角
            imagecornerRadius(userImage)
            
            if myGetOrders.userName  == "Rentsl" && myGetOrders.orderState != "已完成" {
                delButton.setImage(UIImage(named: "che"), forState: .Normal)
                delButton.setImage(UIImage(named: "cheBg"), forState: .Highlighted)
                delButton.setImage(UIImage(named: "cheBg"), forState: .Selected)
            }
            
            orderState.textColor = stateColor(myGetOrders.orderState)
        }else if index == 1 {
            userImage.image = UIImage(data: myOutOrders.userImage!)
            userName.text = myOutOrders.userName
            location.text = myOutOrders.location
            detail.text = myOutOrders.detail
            orderState.text = myOutOrders.orderState
            money.text = myOutOrders.money
            tel.text = myOutOrders.userTel
            time.text = myOutOrders.time
            
            if myOutOrders.userName  == "Rentsl" && myOutOrders.orderState != "已完成" {
                delButton.setImage(UIImage(named: "che"), forState: .Normal)
                delButton.setImage(UIImage(named: "cheBg"), forState: .Highlighted)
                delButton.setImage(UIImage(named: "cheBg"), forState: .Selected)
            }
            
            orderState.textColor = stateColor(myOutOrders.orderState!)
        }

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
