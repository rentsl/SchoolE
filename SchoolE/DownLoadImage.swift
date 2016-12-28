//
//  DownLoadImage.swift
//  SchoolE
//
//  Created by rentsl on 16/11/15.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import Alamofire

protocol DownLoadImgeProtocol: NSObjectProtocol {
    func downImageListener(index: Int, imageData: NSData , info: String)
}

class DownLoadImage{
    var imageNeedReadFromCash: Dictionary<String,String> = [:]
    var delegate: DownLoadImgeProtocol?
    var imageData: NSData?
    func downLoadImageWithURLAndIndex(index: Int,imageURL: String, info:String){
        switch downImageState(imageURL) {
        case "HaveCash":
            self.delegate?.downImageListener(index, imageData: ImageCash.imageDataByURl[imageURL]!, info: info)
        case "DownLoading":
            self.imageNeedReadFromCash[String(index)] = imageURL
        case "NeedDownLoad":
            let trueImageURL = MyURLs.urlDownHeader + imageURL
            print("downLoadImageWithURLAndIndex\(index) info:\(info)")
            Alamofire.request(.GET, trueImageURL)
                .responseData { responds in
                    guard let data = responds.result.value else {return}
                    print("从服务器取到图片\(index)  info:\(info)")
                    //图片缓存
                    ImageCash.imageDataByURl[imageURL] = data
                    self.delegate?.downImageListener(index, imageData: data, info: info)
                    for (key,value) in self.imageNeedReadFromCash {
                        print(key,value)
                        if ImageCash.imageDataByURl[value] != nil {
                            self.delegate?.downImageListener(Int(key)!, imageData: ImageCash.imageDataByURl[value]!, info: info)
                        }
                    }
            }
            //添加到下载队列
            ImageCash.imageDownQueueByURL[imageURL] = imageURL
        case "nil":
            self.delegate?.downImageListener(index, imageData: UIImagePNGRepresentation(UIImage(named:"b004")!)!, info: info)
        default:
            self.delegate?.downImageListener(index, imageData: UIImagePNGRepresentation(UIImage(named:"b004")!)!, info: info)
        }
        
    }
    
    func downImageState(imageURL:String) -> String{
        if imageURL == "" {
            return "nil"
        }else if (ImageCash.imageDataByURl[imageURL]) != nil {
            return "HaveCash"
        }else if (ImageCash.imageDownQueueByURL[imageURL] != nil) {
            return "DownLoading"
        }else{
            return "NeedDownLoad"
        }
    }
}
