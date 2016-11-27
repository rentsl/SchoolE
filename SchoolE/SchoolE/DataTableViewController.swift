//
//  DataTableViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/9/3.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit


class DataTableViewController: UITableViewController,OutAvailableOrdersProtocol,GrabOrderProtocol {
    
    var dataObject: String!
    var isDel = false
    //var orders: [Order] = []
    var selectRow: NSIndexPath?
    var index = 1
    var imageURLs: [String] = []
    var myOutOrders: [OrderLocal] = []
    var userLocal = LoginUser.sharedLoginUser
    let getOrders = SocketGetOutAVOrders()
    var grabJudge = SocketGrabOrder()
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("index:\(index)")
        

        grabJudge.delegate = self
        getOrders.delegate = self
        
        grabJudge.grabOrderListener() //监听是否有人抢单
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
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        hiGetOrders()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
  
            //print(myOutOrders.count)
            return myOutOrders.count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrdersTableViewCell
        
        //cell.textLabel?.text = orders[indexPath.row].money
        
        cell.location.text = myOutOrders[indexPath.row].location
        cell.detail.text = myOutOrders[indexPath.row].detail
        cell.state.text = statusToState(myOutOrders[indexPath.row].status)
        cell.time.text = myOutOrders[indexPath.row].time
            
        cell.state.textColor =  stateColor(statusToState(myOutOrders[indexPath.row].status))

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
            state = "有人抢单"
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

    
    
    
    func hiGetOrders() {
        guard userLocal._id != "" else {return}
        spinner.startAnimating()
        self.getOrders.getOutAvailableOrders()
    }
    
    
    //监听"得到outAvailableOrders"操作
    func outAvailableOrdersListener(data: [OrderLocal]) {
        myOutOrders = data
        
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
        print("刷新列表")
        tableView.reloadData()
    }

    //监听订单是否被抢
    func beGrabbed(data: AnyObject) {
        self.noticeTop("有人抢单!", autoClear: true, autoClearTime: 1)
        self.hiGetOrders()
    }

    

 
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrderDetail2"{
            let destVC = segue.destinationViewController as! OrderDetailViewController2

            destVC.myOutOrders = myOutOrders[tableView.indexPathForSelectedRow!.row]
            destVC.index = index
            destVC.selectRow = tableView.indexPathForSelectedRow

        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func backToOrders2(_: UIStoryboardSegue){
        //if let reviewVC = segue.sourceViewController as? OrderDetailViewController2{
            
    }
    

}
