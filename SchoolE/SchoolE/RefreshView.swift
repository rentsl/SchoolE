//
//  RefreshView.swift
//  SchoolE
//
//  Created by rentsl on 16/11/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

@objc protocol RefreshViewDelegate: NSObjectProtocol {
    @objc optional func refreshViewDidRefresh(refreshView: RefreshView)
    func refreshViewWillRefresh()
}

private let kRefreshViewHeight: CGFloat = 600

private let kSceneHeight: CGFloat = 80.0

class RefreshView: UIView,UIScrollViewDelegate {
    private unowned var scrollView: UIScrollView
    private var progress: CGFloat = 0.0
    
    var refreshItems = [RefreshItem]()
    weak var delegate: RefreshViewDelegate?
    var isRefreshing = false
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: CGRect(x: 0,y: -kRefreshViewHeight,width: scrollView.bounds.width,height: kRefreshViewHeight))
        updataBackgroundColor()
        setupRefreshItems()
    }
    
    func setupRefreshItems(){
        let pinkImageView  = UIImageView(image: UIImage(named: "pinkC"))
        pinkImageView.frame.size.height = 20
        pinkImageView.frame.size.width = 20
        let blueImageView  = UIImageView(image: UIImage(named: "blueC"))
        blueImageView.frame.size.height = 20
        blueImageView.frame.size.width = 20
        let pinkImage2View = UIImageView(image: UIImage(named: "pinkC"))
        pinkImage2View.frame.size.height = 20
        pinkImage2View.frame.size.width = 20
        let blueImage2View = UIImageView(image: UIImage(named: "blueC"))
        blueImage2View.frame.size.height = 20
        blueImage2View.frame.size.width = 20
        let pinkImage3View = UIImageView(image: UIImage(named: "pinkC"))
        pinkImage3View.frame.size.height = 20
        pinkImage3View.frame.size.width = 20
        
        refreshItems = [
            
            RefreshItem(
                view: pinkImageView,
                centerEnd:CGPoint(
                    x: bounds.maxX/4,
                    y: bounds.height - 40
                ),
                parallaxRation:0.5,
                sceneHeight: kSceneHeight
            ),
            RefreshItem(
                view: blueImageView,
                centerEnd:CGPoint(
                    x: bounds.maxX*3/8,
                    y: bounds.height - 40
                ),
                parallaxRation:1.0,
                sceneHeight: kSceneHeight
            ),
            RefreshItem(
                view: pinkImage2View,
                centerEnd:CGPoint(
                    x: bounds.maxX/2,
                    y: bounds.height - 40
                ),
                parallaxRation:1.5,
                sceneHeight: kSceneHeight
            ),
            RefreshItem(
                view: blueImage2View,
                centerEnd:CGPoint(
                    x: bounds.maxX*5/8,
                    y: bounds.height - 40
                ),
                parallaxRation:2.0,
                sceneHeight: kSceneHeight
            ),
            RefreshItem(
                view: pinkImage3View,
                centerEnd:CGPoint(
                    x: bounds.maxX*3/4,
                    y: bounds.height - 40
                ),
                parallaxRation:2.5,
                sceneHeight: kSceneHeight
            )
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }
    
    //MARK storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updataViewPostionForPercentage(progress)
        }
    }
    
    func updataBackgroundColor(){
        backgroundColor = UIColor(white: 0.7 * progress + 0.2,alpha: 1.0)
    }
    
    func beginRefreshing(){
        print("beginRefreshing")
        print("beginRefreshing:\(scrollView.contentOffset)")
        print("beginRefreshing:\(scrollView.contentInset)")
        isRefreshing = true
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
            self.scrollView.contentInset.top += kSceneHeight
        }) {(_) in
            
            print("动画开始!")
            self.delegate?.refreshViewWillRefresh()
            //self.delegate?.refreshViewDidRefresh?(self)
            let fudu: CGFloat = 15
            //MARK: - 动画开始 -
            let pink  = self.refreshItems[0].view
            let blue  = self.refreshItems[1].view
            let pink2 = self.refreshItems[2].view
            let blue2 = self.refreshItems[3].view
            let pink3 = self.refreshItems[4].view
            
            //CGAffineTransformMakeTranslation(0, fudu)
            pink.transform = CGAffineTransformMakeTranslation(0, fudu)
            blue.transform = CGAffineTransformMakeTranslation(0, 0)
            pink2.transform = CGAffineTransformMakeTranslation(0, -fudu)
            blue2.transform = CGAffineTransformMakeTranslation(0, 0)
            pink3.transform = CGAffineTransformMakeTranslation(0, fudu)
            
            UIView.animateWithDuration(0.5, delay: 0, options: [.Repeat,.Autoreverse], animations: {
                pink.transform = CGAffineTransformMakeTranslation(0, -fudu)
                pink2.transform = CGAffineTransformMakeTranslation(0, fudu)
                pink3.transform = CGAffineTransformMakeTranslation(0, -fudu)
                }, completion: nil)
            
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                blue.transform = CGAffineTransformMakeTranslation(0, -fudu)
            }) { (_) in
                UIView.animateWithDuration(0.5, delay: 0, options: [.Repeat,.Autoreverse], animations: {
                    blue.transform = CGAffineTransformMakeTranslation(0, fudu)
                    }, completion: nil)
            }
            
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                blue2.transform = CGAffineTransformMakeTranslation(0, fudu)
            }) { (_) in
                UIView.animateWithDuration(0.5, delay: 0, options: [.Repeat,.Autoreverse], animations: {
                    blue2.transform = CGAffineTransformMakeTranslation(0, -fudu)
                    }, completion: nil)
            }
            
        }
    
        
        
        
        
    }
    
    func endRefreshing(){
        print("endRefreshing")
        print("endRefreshing:\(scrollView.contentOffset)")
        print("endRefreshing:\(scrollView.contentInset)")
        
        UIView.animateWithDuration(0.4, delay: 0.8, options: .CurveEaseInOut, animations: {
            self.scrollView.contentInset.top -= kSceneHeight
            }) { (_) in
                self.isRefreshing = false
                print("动画停止")
                //MARK: - 动画停止 -
                
                let pink  = self.refreshItems[0].view
                let blue  = self.refreshItems[1].view
                let pink2 = self.refreshItems[2].view
                let blue2 = self.refreshItems[3].view
                let pink3 = self.refreshItems[4].view
                //归位
                pink.transform = CGAffineTransformIdentity
                blue.transform = CGAffineTransformIdentity
                pink2.transform = CGAffineTransformIdentity
                blue2.transform = CGAffineTransformIdentity
                pink3.transform = CGAffineTransformIdentity
                //移除动画
                pink.layer.removeAllAnimations()
                blue.layer.removeAllAnimations()
                pink2.layer.removeAllAnimations()
                blue2.layer.removeAllAnimations()
                pink3.layer.removeAllAnimations()
                
        }
        
        
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("触发scrollViewWillEndDragging")
        if !isRefreshing && progress == 1 {
            beginRefreshing()
            print("scrollViewWillEndDragging:\(scrollView.contentInset.top)")
            targetContentOffset.memory.y = -scrollView.contentInset.top
            
            
            //            sleep(UInt32(1))
            //            endRefreshing()
        }
    }
    
    //MARK ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        //1.先拿到刷新视图的可见区域的高度
        let refreshViewVisibleHeight = max(0,-scrollView.contentOffset.y - scrollView.contentInset.top)
        //2.计算当前滚动的进度,范围是0-1
        progress = min(1,refreshViewVisibleHeight/kSceneHeight)
        //3.根据进度来改变背景颜色
        updataBackgroundColor()
        //4.根据进度改变items位置
        updataRefreshItemPositions()
    }
    
}
