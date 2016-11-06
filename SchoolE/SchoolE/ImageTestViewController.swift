//
//  ImageTestViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/11/5.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import Alamofire

class ImageTestViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下载图片 Alamofire 3.5
        Alamofire.request(.GET, "http://121.42.186.184:3000/images/1.png")
        .responseData { responds in
            guard let data = responds.result.value else {return}
            print("下载完成！")
            //print(data)
            self.imageView.image = UIImage(data: data)
        }
        .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            let percent = totalBytesRead*100/totalBytesExpectedToRead
            print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
