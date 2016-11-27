//
//  RGViewPagerController.swift
//  SchoolE
//
//  Created by rentsl on 16/9/3.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import Foundation
import UIKit


class RGViewPagerController: RGPageViewController, RGPageViewControllerDataSource, RGPageViewControllerDelegate {

/******************
*/
    override var pagerOrientation: UIPageViewControllerNavigationOrientation {
        get {
            return .Horizontal
        }
    }
    
    override var tabbarPosition: RGTabbarPosition {
        get {
            return .Top
        }
    }
    
    override var tabbarStyle: RGTabbarStyle {
        get {
            return RGTabbarStyle.Solid
        }
    }
    
    override var tabIndicatorColor: UIColor {
        get {
            return UIColor.whiteColor()
        }
    }
    
    override var barTintColor: UIColor? {
        get {
            return self.navigationController?.navigationBar.barTintColor
        }
    }
    
    override var tabStyle: RGTabStyle {
        get {
            return .InactiveFaded
        }
    }
    
    override var tabbarWidth: CGFloat {
        get {
            return 140.0
        }
    }
    
    override var tabMargin: CGFloat {
        get {
            return 16.0
        }
    }
    
    override var tabbarHeight: CGFloat{
        get{
            return 20.0
        }
    }
    
    override var tabIndicatorWidthOrHeight: CGFloat{
        get{
            return 1.0
        }
    }
    
    override var tabbarTop: CGFloat{
        get{
            return -44.0
        }
    }
    
/*
********************/
    
    let title1 = "我抢到的"
    let title2 = "我发布的"
    var titles: [String]  = []
    

    
    var myOutOrders: [Order] = []
    var myGetOrders: [Order] = []
    
    //var myGetOrders: [Order1] = [Order1(location: "菜鸟驿站", detail: "传媒门口，一个小东西，qq：867620810", money: "6", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "等待确认"),Order1(location: "南一门", detail: "东西有点大，最好是男生，要轻拿轻放，有点贵 qq：867620810", money: "6", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "正在进行"),Order1(location: "南二门", detail: "本人整天不在学校，一个小东西代为保管一天，具体私聊 QQ： 867620810", money: "7", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "已完成")]
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.currentTabIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.currentTabIndex = 0
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.barStyle = .Black
//        //关闭半透明(可以解决右侧黑块问题)
//        //self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.setPinkStyle()
        
        
        titles = [title1,title2]
                
        datasource = self
        delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPagesForViewController(pageViewController: RGPageViewController) -> Int {
        return 2
    }
    
    func tabViewForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIView {
        var tabView: UIView!
        
        tabView = UILabel()
        
        (tabView as! UILabel).font = UIFont.systemFontOfSize(14)
        (tabView as! UILabel).text = titles[index]
        (tabView as! UILabel).textColor = UIColor.whiteColor()
        
        (tabView as! UILabel).sizeToFit()
        
        return tabView
    }
    
    func viewControllerForPageAtIndex(pageViewController: RGPageViewController, index: Int) -> UIViewController? {
        if (titles.count == 0) || (index >= titles.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        
        if index == 0 {
            let dataTableViewController0 = storyboard!.instantiateViewControllerWithIdentifier("DataTableViewController3") as! DataTableViewController3
            dataTableViewController0.index = 0
            return dataTableViewController0
        }else if index == 1 {
            let dataTableViewController1 = storyboard!.instantiateViewControllerWithIdentifier("DataTableViewController") as! DataTableViewController
            dataTableViewController1.index = 1
            return dataTableViewController1
        }
        
        //return dataTableViewController
        return nil
    }
    
    func heightForTabAtIndex(index: Int) -> CGFloat {
        return 164.0
    }
    
    func widthForTabAtIndex(index: Int) -> CGFloat {
        var tabSize = UIScreen.mainScreen().bounds.size
        //tabSize.width += 32
        tabSize.width = tabSize.width/2 - 16
        
        return tabSize.width
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addBackToRGViewPager(segue: UIStoryboardSegue) {
        
    }

}
