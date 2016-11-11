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

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var userLogin = LoginUser.sharedLoginUser
    var orders:[Order] = []
    var user: [User] = []

    var frc: NSFetchedResultsController!
    
    //var socket = WebSocket(url: NSURL(string: "ws://121.42.186.184:3000")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //属性设置
        /*1******************************************************************/
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if let font = UIFont(name: "Avenir-Light", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName:font
            ]
        }
        
//        //关闭半透明(可以解决右侧黑块问题)
//        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.barStyle = .Black
        /*1******************************************************************/
        
        let request = NSFetchRequest(entityName: "Order")
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: buffer!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
            orders =  frc.fetchedObjects as! [Order]
        } catch {
            print(error)
        }
        
        /*3******************************************************************/
        //获取cocodata中User实体，放入user中
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
        /*3******************************************************************/
        
        //wesocket测试
        

//            socket.delegate = self
//            socket.connect()
//            print("myWebsocket")


        
    }

    
    //NSFetchedResultsControllerDelegate
    //当cocodate中的数据发生变化时调用
/*2******************************************************************/
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Automatic)
                
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
            }
            
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
            }
        default:
            tableView.reloadData()
            
        }
        
        orders = controller.fetchedObjects as! [Order]
    }
/*2******************************************************************/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.location.text = orders[indexPath.row].location
        cell.detail.text = orders[indexPath.row].detail
        cell.money.text = orders[indexPath.row].money
        cell.userImage.image = UIImage(data: orders[indexPath.row].userImage!)
        //我也不知道为什么要重新设置大小
        cell.userImage.frame = CGRectMake(172.5,152.0,30.0,30.0)
        cell.time.text = orders[indexPath.row].time
        
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
            
            destVC.order = orders[(tableView.indexPathForSelectedRow!.row)]
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
   
    
    
    
//    // MARK: Websocket Delegate Methods.
//    
//    func websocketDidConnect(ws: WebSocket) {
//        print("websocket is connected")
//    }
//    
//    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
//        if let e = error {
//            print("websocket is disconnected: \(e.localizedDescription)")
//        } else {
//            print("websocket disconnected")
//        }
//    }
//    
//    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
//        print("Received text: \(text)")
//    }
//    
//    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
//        print("Received data: \(data.length)")
//    }
    

}
