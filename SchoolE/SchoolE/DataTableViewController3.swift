//
//  DataTableViewController3.swift
//  SchoolE
//
//  Created by rentsl on 16/9/5.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class DataTableViewController3: UITableViewController,GetActiveOrdersProtocol,RefuseOrderProtocol,ConfirmOrderProtocol {

    var index = 0
    var imageURLs: [String] = []
    var selectRow: NSIndexPath?
    var userLocal = LoginUser.sharedLoginUser
    var myGetOrders: [OrderLocal] = []
    let getOrders = SocketGetGetActiveOrders()
    let refusedListener = RefuseOrder()
    let comfirmedListener = ConfirmOrder()
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("index:\(index)")
        //myGetorderStateListener()
    
        getOrders.delegate = self
        refusedListener.delegate = self
        comfirmedListener.delegate = self
        
        refusedListener.refusedListener()     //监听是否被拒接
        comfirmedListener.comfirmedListener() //监听是否被接受
        
        hiGetOrders() //请求获取数据
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "hiGetOrders", forControlEvents: .ValueChanged)
        
        
        //UI属性操作
        /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线
        /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        hiGetOrders()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGetOrders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell3", forIndexPath: indexPath) as! OrdersTableViewCell
        
        cell.location.text = myGetOrders[indexPath.row].location
        cell.detail.text = myGetOrders[indexPath.row].detail
        cell.state.text = statusToState(myGetOrders[indexPath.row].status)
        cell.time.text = myGetOrders[indexPath.row].time
        
        cell.state.textColor =  stateColor(statusToState(myGetOrders[indexPath.row].status))
        
        // Configure the cell...

        return cell
    }
    
    //状态着色
    func stateColor(state: String) -> UIColor {
        var color: UIColor
        switch state {
        case "等人抢单":
            color = UIColor(red: 153/225, green: 204/225, blue: 51/225, alpha: 1)
        case "有人抢单":
            color = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        case "正在进行":
            color = UIColor(red: 102/225, green: 204/225, blue: 204/225, alpha: 1)
        case "已完成":
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        case "等待确认":
            color = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        case "已取消":
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        default:
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        }
        return color
    }
    
    //状态转换 服务端->客户端
    func statusToState(status:String) -> String{
        var state:String
        switch status {
        case "available":
            state = "等人抢单"
        case "grabbed":
            state = "等待确认"
        case "confirmed":
            state = "正在进行"
        case "onRoad":
            state = "正在进行"
        case "reached":
            state = "正在进行"
        case "finished":
            state = "已完成"
        case "cancelled":
            state = "已取消"
        case "error":
            state = "点单错误"
        default:
            state = "等人抢单"
        }
        return state
    }
    
    
    //请求数据
    func hiGetOrders(){
        guard userLocal._id != "" else {return}
        spinner.startAnimating()
        getOrders.getGetActiveOrders()
    }
    
    
    //监听抢到的订单是否被接受
    func beComfirmed() {
        self.noticeTop("你有订单被确认", autoClear: true, autoClearTime: 1)
        self.hiGetOrders()
    }
    
    //监听抢到的订单是否被拒接
    func beRefuse() {
        self.noticeTop("你有订单被拒接", autoClear: true, autoClearTime: 1)
        self.hiGetOrders()
    }
    
    //监听"得到GetActiveOrders"操作
    func getActiveOrdersListener(data: [OrderLocal]) {
        
        myGetOrders = data
        imageURLs.removeAll()
        for order in myGetOrders {
            self.imageURLs.append(order.publisherImageID)
        }
        //print(data)
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
        print("刷新列表")
        tableView.reloadData()
    }


   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrderDetail3"{
            let destVC = segue.destinationViewController as! OrderDetailViewController3
            
            destVC.myGetOrder = myGetOrders[tableView.indexPathForSelectedRow!.row]
            destVC.imageURL = imageURLs[tableView.indexPathForSelectedRow!.row]
            destVC.index = index
            destVC.selectRow = tableView.indexPathForSelectedRow
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
