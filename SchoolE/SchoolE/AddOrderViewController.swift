//
//  AddOrderViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/7/30.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class AddOrderViewController: UIViewController {

    var order: Order!
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBAction func addOrder(sender: UIBarButtonItem) {
        
        if location.text == "" || detail.text == "" || money.text == "" || tel.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        let order = NSEntityDescription.insertNewObjectForEntityForName("Order", inManagedObjectContext: buffer!) as! Order
        
        order.location = location.text
        order.detail = detail.text
        order.money = money.text
        order.userTel = tel.text
        order.userName = "Rentsl"
        order.userImage = UIImagePNGRepresentation(UIImage(named: "b004")!)
        order.time = "2016-07-15 21:34:10"
        order.orderState = "等人抢单"
        
        do {
            try  buffer?.save()
        } catch {
            print(error)
        }
        
        //退场
        performSegueWithIdentifier("backToRGPageView", sender: sender)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar自定义
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func 判断哪些信息没填() {
        if location.text == nil || detail.text == nil || money.text == nil || tel.text == nil {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
        }
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
