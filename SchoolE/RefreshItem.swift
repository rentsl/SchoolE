//
//  RefreshItem.swift
//  SchoolE
//
//  Created by rentsl on 16/11/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class RefreshItem {
    private var centerStart: CGPoint
    private var centerEnd: CGPoint
    unowned var view: UIView
    
    init(view: UIView,centerEnd:CGPoint,parallaxRation:CGFloat,sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        self.centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRation * sceneHeight))
        self.view.center = centerStart
    }
    
    func updataViewPostionForPercentage(percentage: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage
        )
    }
    
}
