//
//  DownLoadImage.swift
//  SchoolE
//
//  Created by rentsl on 16/11/15.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import Alamofire

class DownLoadImage{
     var delegate: DownLoadImgeProtocol?
    func downLoadImageWithURLAndIndex(index: Int,imageURL: String, info:String){
        print("downLoadImageWithURLAndIndex\(index) info:\(info)")
        Alamofire.request(.GET, imageURL)
            .responseData { responds in
                guard let data = responds.result.value else {return}
                self.delegate?.getDownImage(index, imageData: data, info: info)
                print("从服务器取到图片\(index)  info:\(info)")
        }
    }
}
