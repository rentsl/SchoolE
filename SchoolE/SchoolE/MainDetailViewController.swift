//
//  MainDetailViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/7/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class MainDetailViewController: UIViewController {

    var order:Order!
    var orderLocal:OrderLocal!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBAction func qiang(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.image = UIImage(data: orderLocal.publisherImage!)
        userName.text = orderLocal.publisherName
        location.text = orderLocal.location
        detail.text = orderLocal.detail
        money.text = orderLocal.cost
        tel.text = orderLocal.publisherTel
        time.text = orderLocal.time
        userImage.frame = CGRectMake(0.0, 0.0, 50.0, 50.0)
        
        //图片圆角
        imagecornerRadius(userImage)
        
        // Do any additional setup after loading the view.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
