//
//  DataTableViewController3.swift
//  SchoolE
//
//  Created by rentsl on 16/9/5.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewController3: UITableViewController,NSFetchedResultsControllerDelegate {

    var isDel = false
    var frc: NSFetchedResultsController!
    var index = 0
    var selectRow: NSIndexPath?
    var myGetOrders: [MyGetOrder] = []
    //var myGetOrders: [Order1] = [Order1(location: "菜鸟驿站", detail: "传媒门口，一个小东西，qq：867620810", money: "6", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "等待确认"),Order1(location: "南一门", detail: "东西有点大，最好是男生，要轻拿轻放，有点贵 qq：867620810", money: "6", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "正在进行"),Order1(location: "南二门", detail: "本人整天不在学校，一个小东西代为保管一天，具体私聊 QQ： 867620810", money: "7", userImage: "b004", userName: "Rentsl", time: "2016-7-15 21:34:10", userTel: "18906622309", orderState: "已完成")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去掉系统自带的分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let request = NSFetchRequest(entityName: "MyGetOrder")
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: buffer!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        
        do {
            try frc.performFetch()
            myGetOrders =  frc.fetchedObjects as! [MyGetOrder]
        } catch {
            print(error)
        }
        
        
        /*2******************************************************************/
        func controllerWillChangeContent(controller: NSFetchedResultsController) {
            tableView.beginUpdates()
        }
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
            tableView.endUpdates()
        }
        
        func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            //不是很理解 这里的if语句
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
            
            myGetOrders = controller.fetchedObjects as! [MyGetOrder]
        }
        /*2******************************************************************/


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.state.text = myGetOrders[indexPath.row].orderState
        cell.time.text = myGetOrders[indexPath.row].time
        
        cell.state.textColor =  stateColor(myGetOrders[indexPath.row].orderState!)
        
        // Configure the cell...

        return cell
    }
    
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
        default:
            color = UIColor(red: 161/225, green: 161/225, blue: 161/225, alpha: 1)
        }
        return color
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
