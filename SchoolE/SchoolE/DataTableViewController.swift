//
//  DataTableViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/9/3.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class DataTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,OutAvailableOrderslisten {
    
    var dataObject: String!
    var frc: NSFetchedResultsController!
    var isDel = false
    //var orders: [Order] = []
    var selectRow: NSIndexPath?
    var index = 1
    var imageURLs: [String] = []
    var myOutOrders: [OrderLocal] = []
    var userLocal = LoginUser.sharedLoginUser
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("index:\(index)")

        let getOrders = SocketGetOutAVOrders()
        getOrders.delegate = self
        getOrders.getOutAvailableOrders()
        
        getOrdersRequest() //请求获取数据
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getOrdersRequest", forControlEvents: .ValueChanged)
        
        
        //UI属性操作
        /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线
        /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        
        
        
        
        
        
        //本地cocodata数据请求
        /*--------------------------------------------------------------*/
        //let request = NSFetchRequest(entityName: "Order")
        //request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        //let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        //frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: buffer!, sectionNameKeyPath: nil, cacheName: nil)
        //frc.delegate = self
        //
        //
        //do {
        //    try frc.performFetch()
        //    myOutOrders =  frc.fetchedObjects as! [Order]
        //} catch {
        //    print(error)
        //}
        /*--------------------------------------------------------------*/
    }
    
    
    
    
    
    
    //cocodata中数据发生变化时执行
    
    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    //func controllerWillChangeContent(controller: NSFetchedResultsController) {
    //    tableView.beginUpdates()
    //}
    //
    //func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //    tableView.endUpdates()
    //}
    //
    //func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    //    //不是很理解 这里的if语句
    //    if self.index ==  1 {
    //        switch type {
    //        case .Insert:
    //            if let _newIndexPath = newIndexPath {
    //                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Automatic)
    //            }
    //        case .Delete:
    //            if let _indexPath = indexPath {
    //                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
    //            }
    //
    //        case .Update:
    //            if let _indexPath = indexPath {
    //                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
    //            }
    //        default:
    //            tableView.reloadData()
    //
    //        }
    //    }
    //
    //    myOutOrders = controller.fetchedObjects as! [Order]
    //}
    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    override func viewDidAppear(animated: Bool) {
        getOrdersRequest()
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

    
    
    
    func getOrdersRequest() {
        guard userLocal._id != "" else {return}
        spinner.startAnimating()
        if self.userLocal._id != "" {
            print("getOutActiveOrdersRequest")
            let items = ["method":"published order",
                         "_id":self.userLocal._id,
                         "token":self.userLocal.token]
            SocketConnect.socket.emit("published order", items)
        }
    }
    
    
    
    //监听"得到outAvailableOrders"操作
    func getNewOutAvailableOrders(data: AnyObject) {
        print("getNewOutAvailableOrders")
        
        //将data转成JSON格式
        let dataString = String((data as! NSArray)[0])
        let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let dataJson = JSON(data:jsonData!)
        //print(dataJson)
        
        myOutOrders.removeAll()
        for i in 0..<dataJson["data"].count {
            imageURLs.append(dataJson["data"][i]["publisher_avatar"].string!)
            myOutOrders.append(OrderLocal(
                publisherImage: UIImagePNGRepresentation(UIImage(named:"b004")!),
                publisherName: dataJson["data"][i]["publisher_name"].string!,
                location: dataJson["data"][i]["location"].string!,
                status: dataJson["data"][i]["status"].string!,
                detail: dataJson["data"][i]["detail"].string!,
                cost: String(dataJson["data"][i]["cost"]),
                publisherTel: String(dataJson["data"][i]["phone"]),
                time: dataJson["data"][i]["time"].string!,
                publisherID: dataJson["data"][i]["publisher"].string!,
                id: dataJson["data"][i]["_id"].string!,
                receiver: dataJson["data"][i]["receiver"].string!))
        }
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    



 
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrderDetail2"{
            let destVC = segue.destinationViewController as! OrderDetailViewController2

            destVC.myOutOrders = myOutOrders[tableView.indexPathForSelectedRow!.row]
            destVC.imageURL = imageURLs[tableView.indexPathForSelectedRow!.row]
            destVC.index = index
            destVC.selectRow = tableView.indexPathForSelectedRow

        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func backToOrders2(_: UIStoryboardSegue){
        //if let reviewVC = segue.sourceViewController as? OrderDetailViewController2{
            
            //本地cocodata删除操作
            /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
            //if let _isDel = reviewVC.isDel{
            //    self.isDel = _isDel
            //
            //}
            //
            //if let _selectRow = reviewVC.selectRow{
            //    self.selectRow = _selectRow
            //}
            //
            ////删除订单
            //
            //print("hi")
            //print(self.isDel)
            //if isDel == true {
            //    print("hi")
            //    let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
            //    let orderToDel = frc.objectAtIndexPath(selectRow!) as! Order
            //    buffer?.deleteObject(orderToDel)
            //
            //    do {
            //        try buffer?.save()
            //    } catch {
            //        print(error)
            //    }
            //
            //    self.notice("删除成功", type: NoticeType.success, autoClear: true)
            //
            //}
            /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
       // }
    }
    

}
