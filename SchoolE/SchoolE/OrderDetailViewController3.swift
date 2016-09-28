//
//  OrderDetailViewController3.swift
//  SchoolE
//
//  Created by rentsl on 16/9/9.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class OrderDetailViewController3: UIViewController {

    var myGetOrder: MyGetOrder!
    var selectRow: NSIndexPath?
    var isDel: Bool?
    
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
        isDel = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.image = UIImage(data: myGetOrder.userImage!)
        userName.text = myGetOrder.userName
        location.text = myGetOrder.location
        detail.text = myGetOrder.detail
        orderState.text = myGetOrder.orderState
        money.text = myGetOrder.money
        tel.text = myGetOrder.userTel
        time.text = myGetOrder.time
        
        //图片圆角
        imagecornerRadius(userImage)
        
        if myGetOrder.userName  == "Rentsl" && myGetOrder.orderState != "已完成" {
            delButton.setImage(UIImage(named: "che"), forState: .Normal)
            delButton.setImage(UIImage(named: "cheBg"), forState: .Highlighted)
            delButton.setImage(UIImage(named: "cheBg"), forState: .Selected)
        }
        
        orderState.textColor = stateColor(myGetOrder.orderState!)

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
