//
//  MainTableViewCell.swift
//  SchoolE
//
//  Created by rentsl on 16/7/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

var beginPoint: CGPoint = CGPoint.init(x: 0, y: 230)
var endPoint: CGPoint = CGPoint.init(x: UIScreen.mainScreen().bounds.height, y: 230)

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //自定义分割线
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let lengths : [CGFloat] = [1,2]
        CGContextSetLineDash(context!, 0, lengths, 2)
        CGContextMoveToPoint(context!, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context!, endPoint.x, endPoint.y)
        CGContextStrokePath(context!)
        
    }

}
