//
//  AddOrderViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/7/30.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class AddOrderViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let schoolElocation = ["五号楼","菜鸟驿站","博研书店","南一门"]
    
    var systemTime = SystemTime.sharedTime
    var userLogin = LoginUser.sharedLoginUser
    var order: Order!
    
    @IBOutlet var locationPicker: UIPickerView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBAction func addOrder(sender: UIBarButtonItem) {
        guard userLogin._id != "" else {
            notice("请先登录", type: NoticeType.info, autoClear: true, autoClearTime: 1)
            return
        }
        
        if location.text == "" || detail.text == "" || money.text == "" || tel.text == "" {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
            return
        }
        
        if userLogin._id == "" || userLogin.token == "" { return }
        
        orderPublishRequest()
        //退场
        performSegueWithIdentifier("backToRGPageView", sender: sender)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setWhiteStyle() //navigationBar自定义
        locationPicker.center = view.center
        locationPicker.backgroundColor = UIColor.whiteColor()
        locationPicker.delegate = self
        locationPicker.dataSource = self
        location.inputView = locationPicker
        
        tel.text = userLogin.userTel
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func orderPublishRequest(){
        guard userLogin._id != "" else {return}
        let orderinformation = ["method":"order pulish","_id":self.userLogin._id,"token":self.userLogin.token,"data":["location":self.location.text!,"cost":money.text!,"phone":tel.text!,"detail":self.detail.text!]]
        SocketConnect.socket.emit("order publish", orderinformation)
    }

    func 判断哪些信息没填() {
        if location.text == nil || detail.text == nil || money.text == nil || tel.text == nil {
            notice("完善信息", type: NoticeType.info, autoClear: true, autoClearTime: 2)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.schoolElocation[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.location.text = self.schoolElocation[row]
        self.locationPicker.removeFromSuperview()
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
