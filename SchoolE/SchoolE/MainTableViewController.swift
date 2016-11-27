//
//  MainTableViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/7/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController ,AvailableOrdersProtocol,DownLoadImgeProtocol,ActiveOrdersListenProtocol{

    var userLogin = LoginUser.sharedLoginUser
    var orders:[Order] = []
    var user: [User] = []
    var ordersLocal : [OrderLocal] = []
    var imageNeedReadFromCash: Dictionary<String,String> = [:]
    let getImage = DownLoadImage()
    let getOrders = AvailableOrdersDataSource()
    let activeOrdersListener = ActiveOrdersListen()
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImage.delegate = self
        getOrders.delegate = self
        activeOrdersListener.delegate = self
        
        activeOrdersListener.activeOrderListener() //启动监听
        
        /* 获取数据
         * 当进入这个页面时,
         * AppDelegate中的SocketIO还没连上,
         * 所以这里的监听能得带反馈,但是及其不安全
         */
        SocketConnect.socket.once("connect") { data,ack in
            self.getOrders.getAvailableOrders(self.userLogin._id)
        }
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "hiGetOrders", forControlEvents: .ValueChanged)
        
        
        
        //属性设置
        /*-----------------------------------------------------------------*/
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线
        self.navigationController?.navigationBar.setPinkStyle()
        /*-----------------------------------------------------------------*/
        
    }

    override func viewDidAppear(animated: Bool) {
        //getOrdersRequest()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    
    @IBAction func reflash(sender: UIBarButtonItem) {
        hiGetOrders()
    }
    

    
    func hiGetOrders(){
        getOrders.getAvailableOrders(userLogin._id)
    }
    
    
    //监听并接收AvailableOrders并发出图片下载请求
    func availableOrdersListener(data: [OrderLocal]) {
        ordersLocal = data
        var i = 0
        for order in ordersLocal{
            getImage.downLoadImageWithURLAndIndex(i, imageURL:order.publisherImageID , info: "")
            i = i + 1
        }
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    
    //监听"下载图片"事件
    func downImageListener(index: Int, imageData: NSData, info:String) {
        ordersLocal[index].publisherImage = imageData
        tableView.reloadData()
    }
    
    //active订单发生变化时返回变化订单的状态(一个)
    func activeOrderDidChange(state:String) {
        switch state {
        case _new:
            self.hiGetOrders()
        case _remove:
            self.hiGetOrders()
        case _vary:
            break
        default:
            break
        }
    }
    
    //active订单发生变化时返回一堆订单
    func activeOrdersDidChange() {
        //貌似没什么用...
    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ordersLocal.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.location.text = ordersLocal[indexPath.row].location
        cell.detail.text = ordersLocal[indexPath.row].detail
        cell.money.text = ordersLocal[indexPath.row].cost
        cell.userImage.image = UIImage(data: ordersLocal[indexPath.row].publisherImage!)
        //我也不知道为什么要重新设置大小
        //cell.userImage.frame = CGRectMake(0.0,0.0,30.0,30.0)
        cell.userImage.frame.size.width = 30.0
        cell.userImage.frame.size.height = 30.0
        cell.time.text = ordersLocal[indexPath.row].time
        
        //图片圆角
        imagecornerRadius(cell.userImage)

        // Configure the cell...

        return cell
    }
    

    //图片圆角
    func imagecornerRadius(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMainDetail" {
            let destVC = segue.destinationViewController as! MainDetailViewController
            
            destVC.orderLocal = ordersLocal[(tableView.indexPathForSelectedRow!.row)]
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
   
    @IBAction func mainDetailBack(_ : UIStoryboardSegue){
        
    }

}


