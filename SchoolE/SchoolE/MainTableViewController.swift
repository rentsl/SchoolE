//
//  MainTableViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/7/29.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData
import Starscream
import SwiftyJSON

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate ,AvailableOrderslisten,DownLoadImgeProtocol{

    var userLogin = LoginUser.sharedLoginUser
    var orders:[Order] = []
    var user: [User] = []
    
    var ordersLocal : [OrderLocal] = []

    var frc: NSFetchedResultsController!
    
    
    
    let getImage = DownLoadImage()
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        ordersListener()
        orderListener()
        
        getImage.delegate = self
        
        let getOrders = SocketGetAvailableOrders()
        getOrders.delegate = self
        getOrders.getAvailableOrders()
        
        /*获取数据
         *当进入这个页面时,
         *AppDelegate中的SocketIO还没连上,
         *所以这里的监听能得带反馈,但是及其不安全
         */
        SocketConnect.socket.once("connect") { data,ack in
            self.getOrdersRequest()
        }
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getOrdersRequest", forControlEvents: .ValueChanged)
        
        
        
        //属性设置
        /*-----------------------------------------------------------------*/
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName:font
            ]
        }
        //self.navigationController?.navigationBar.translucent = false //关闭半透明(可以解决右侧黑块问题)
        self.navigationController?.navigationBar.barStyle = .Black
        /*-----------------------------------------------------------------*/
        
        
        
        
        
        
        //获取cocodata中的Order列表,放入orders中
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        //  let request = NSFetchRequest(entityName: "Order")
        //  request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        //  let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        //  frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: buffer!, sectionNameKeyPath: nil, cacheName: nil)
        //  frc.delegate = self
        //
        //  do {
        //      try frc.performFetch()
        //      orders =  frc.fetchedObjects as! [Order]
        //  } catch {
        //      print(error)
        //  }
        /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
        
        
        
        
        //获取cocodata中User实体，放入user中
        /*-----------------------------------------------------------------*/
        //**参考用**
        //
        //        let userRequest = NSFetchRequest(entityName: "User")
        //
        //        do{
        //            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
        //
        ////            //遍历值
        ////            for info:User in user {
        ////                print("hi")
        ////                print("password=\(info.password)")
        ////            }
        //
        //        }catch{
        //            print(error)
        //        }
        //
        //        //在cocodata中存入第一组用户数据
        //        if user.count == 0 {
        //
        //            let addUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: buffer!) as! User
        //
        //            addUser.name = user1.name
        //            addUser.password = user1.password
        //            addUser.paynumber = user1.payNumber
        //            addUser.school = user1.school
        //            addUser.studentID = user1.studentID
        //            addUser.userImage = UIImagePNGRepresentation(UIImage(named: user1.userImage)!)
        //            addUser.userName = user1.userName
        //            addUser.userTel = user1.userTel
        //
        //            do {
        //                try  buffer?.save()
        //            } catch {
        //                print(error)
        //            }
        //
        //        }
        
        //        //检查cocodata中User中的数据
        //        do{
        //            self.user = try buffer!.executeFetchRequest(userRequest) as! [User]
        //
        //                        //遍历值
        //                        for info:User in user {
        //                            print("hi")
        //                            print("password=\(info.password)")
        //                        }
        //
        //        }catch{
        //            print(error)
        //        }
        /*-----------------------------------------------------------------*/
        

        
    }

    override func viewDidAppear(animated: Bool) {
        //getOrdersRequest()
    }
    
    //NSFetchedResultsControllerDelegate
    //当cocodate中的数据发生变化时调用
    /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    //
    //func controllerWillChangeContent(controller: NSFetchedResultsController) {
    //    tableView.beginUpdates()
    //}
    //
    //func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //    tableView.endUpdates()
    //}
    //
    //func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    //    switch type {
    //    case .Insert:
    //        if let _newIndexPath = newIndexPath {
    //            tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Automatic)
    //
    //        }
    //    case .Delete:
    //        if let _indexPath = indexPath {
    //            tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
    //        }
    //
    //    case .Update:
    //        if let _indexPath = indexPath {
    //            tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
    //        }
    //    default:
    //        tableView.reloadData()
    //
    //    }
    //
    //    orders = controller.fetchedObjects as! [Order]
    //}
    /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    @IBAction func reflash(sender: UIBarButtonItem) {
        getOrdersRequest()
    }
    
    
    
    func getOrdersRequest() {
        spinner.startAnimating()
        let items = ["hi"]
        SocketConnect.socket.emit("get orders", items)  
    }
    
//    //通过OrderID来找它在ordersLocal中的位置
//    func findIndexByOrderID(OrderID:String) -> NSIndexPath{
//        
//    }
    
    
    //监听单个AV订单是否发生变化(发送一个订单,删除,增加等)
    func orderListener() {
        SocketConnect.socket.on("order changes") { data, ack in
            print("orderListener")
            //将data转成JSON格式
            let dataString = String((data as NSArray)[0])
            let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let dataJson = JSON(data:jsonData!)
            print(dataJson)
            
            switch dataJson["changes"] {
            case "new":
                self.getOrdersRequest()
            case "remove":
                break
            case "vary":
                break
            default:
                break
            }
            
            self.noticeTop("活跃订单有变化", autoClear: true, autoClearTime: 1)
        }
    }
   
    //监听AV订单是否发生变化(发送整个订单组)
    func ordersListener() {
        SocketConnect.socket.on("orders changed") { data, ack in
            print("ordersListener")
            //self.noticeTop("有新订单", autoClear: true, autoClearTime: 1)
        }
    }
    
    
    //监听并接收AvailableOrders
    func getNewAvailableOrders(data: AnyObject) {
        print("getNewAvailableOrders")
        //print(data)
        //将data转成JSON格式
        let dataString = String((data as! NSArray)[0])
        let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var dataJson = JSON(data:jsonData!)
        print("avOrdersCount:\(dataJson["data"].count)")
        
        var imageData: NSData?
        ordersLocal.removeAll()
        var j = 0
        for i in 0..<dataJson["data"].count where (dataJson["data"][i]["publisher"].string != userLogin._id){
            let imageCashDidFilter = ImageCash.availableOrderImage
            print("imageCashDidFilter:\(imageCashDidFilter.count)")
            let imageCash = imageCashDidFilter.filter {$0.0 == dataJson["data"][i]["publisher"].string!}
            if imageCash.count != 0{
                imageData = imageCash[0].1
            }else{
                imageData = UIImagePNGRepresentation(UIImage(named:"b004")!)
                //获取用户头像并在回调函数中刷新视图
                getImage.downLoadImageWithURLAndIndex(j, imageURL: (MyURLs.urlDownHeader + dataJson["data"][i]["publisher_avatar"].string!),info: dataJson["data"][i]["publisher"].string!)
            }
            ordersLocal.append(OrderLocal(
                publisherImage: imageData,
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
            j = j + 1
        }
        print("j:\(j)")
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    
    
    //监听"下载图片"事件
    func getDownImage(index: Int, imageData: NSData, info:String) {
        ordersLocal[index].publisherImage = imageData
        //图片缓存
        ImageCash.availableOrderImage[info] = imageData
        tableView.reloadData()
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

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
