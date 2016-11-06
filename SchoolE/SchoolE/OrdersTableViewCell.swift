//
//  OrdersTableViewCell.swift
//  SchoolE
//
//  Created by rentsl on 16/7/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    var beginPoint: CGPoint = CGPoint.init(x: 0, y: 150)
    var endPoint: CGPoint = CGPoint.init(x: UIScreen.mainScreen().bounds.height, y: 150)
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var state: UILabel!
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
