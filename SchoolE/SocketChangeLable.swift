//
//  SocketChangeLable.swift
//  SchoolE
//
//  Created by rentsl on 16/11/13.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import SocketIO

class SocketChangeLable{
    var delegate: ChangeLable?
    
    func changeL() {
        if delegate != nil {
            SocketConnect.socket.on("bc", callback: { data,ack in
                self.delegate?.changeLable(String(data))
            })
        }
    }
}
