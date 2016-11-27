//
//  HistoryOrdersTableViewController.swift
//  SchoolE
//
//  Created by rentsl on 16/11/23.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class HistoryOrdersTableViewController: UITableViewController,historyOrdersProtocol {

    //data
    /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    var userLocal = LoginUser.sharedLoginUser
    var historyOrders: [OrderLocal] = []
    var historyOrdersDataSource = HistoryOrdersDataSource()
    /*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyOrdersDataSource.delegate = self
        historyOrdersDataSource.getHistoryOrders()
        
        //属性设置
        /*-----------------------------------------------------------------*/
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None //去掉系统自带的分割线
        self.navigationController?.navigationBar.setWhiteStyle()
        /*-----------------------------------------------------------------*/

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyOrders.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as!  OrdersTableViewCell
        cell.detail.text = historyOrders[indexPath.row].detail
        cell.location.text = historyOrders[indexPath.row].location
        cell.state.text = historyOrders[indexPath.row].location
        cell.time.text = historyOrders[indexPath.row].time
        
        return cell
    }
    
//    func historyOrdersRequest(){
//        guard self.userLocal._id != "" else {return}
//        
//        let items = ["method":"history published",
//                     "_id":self.userLocal._id,
//                     "token":self.userLocal.token]
//        SocketConnect.socket.emit("history published", items)
//   }
//
//    func historyOrdersListen(){
//        print("historyOrdersListen")
//        SocketConnect.socket.once("history published") { data,ack in
//            let dataJson = MyTools.socketIODataToJSON(data)
//            print("gethistorydata")
//            print(dataJson)
//            self.historyOrders.removeAll()
//            
//            for i in 0..<dataJson["data"].count {
//                self.historyOrders.append(OrderLocal(
//                    publisherImage: nil,
//                    publisherName: dataJson["data"][i]["publisher"].string!,
//                    location: dataJson["data"][i]["location"].string!,
//                    status: dataJson["data"][i]["status"].string!,
//                    detail: dataJson["data"][i]["detail"].string!,
//                    cost: "",
//                    publisherTel: "",
//                    time: dataJson["data"][i]["time"].string!,
//                    publisherID: "",
//                    id: "",
//                    receiver: ""
//                    )
//                )
//            }
//            self.tableView.reloadData()
//        }
//        historyOrdersRequest()
//    }
    
    func historyOrdersListener(historyOrders: [OrderLocal]) {
        self.historyOrders = historyOrders
        self.tableView.reloadData()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
