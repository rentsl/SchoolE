//
//  SystemTime.swift
//  SchoolE
//
//  Created by rentsl on 16/10/14.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation

class SystemTime: NSObject {
    static internal let sharedTime = SystemTime()
    private override init() {
        print("生成时间单例")
    }
    
    func getTime() ->(String) {
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }
    func getNoBlankTime() -> (String){
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }
}
