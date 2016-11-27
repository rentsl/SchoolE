//
//  UIBarExtension.swift
//  SchoolE
//
//  Created by rentsl on 16/8/2.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

//by Rentsl
extension UINavigationBar{
    
    func setPinkStyle(){
        self.barTintColor = UIPinkColor
        self.tintColor = UIColor.whiteColor()
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName:font
            ]
        }
        self.hideBottomHairline()
        //关闭半透明
        self.translucent = false
        self.barStyle = .Black
    }
    
    func setWhiteStyle(){
        self.hideBottomHairline()
        self.barTintColor = UIColor.whiteColor()
        self.tintColor = UIPinkColor
        //关闭半透明
        self.translucent = false
        
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.titleTextAttributes = [
                NSForegroundColorAttributeName:UIPinkColor,
                NSFontAttributeName:font
            ]
        }
        self.barStyle = .Default

    }
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}
