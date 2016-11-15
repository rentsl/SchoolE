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
    static var delegate: DownLoadImgeProtocol?
    static func downLoadImageWithURLAndIndex(index: Int,imageURL: String){
        Alamofire.request(.GET, imageURL)
            .responseData { responds in
                guard let data = responds.result.value else {return}
                delegate?.getDownImage(index, imageData: data)
        }
    }
}
