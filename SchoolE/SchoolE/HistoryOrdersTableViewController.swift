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
        self.navigationController?.navigationBar.setPinkStyle()
        /*-----------------------------------------------------------------*/

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
        cell.state.text = historyOrders[indexPath.row].status
        cell.time.text = historyOrders[indexPath.row].time
        cell.stateImage.image = historyOrders[indexPath.row].status == _finished
            ? UIImage(named: "finsh"): UIImage(named: "cancel")
        
        return cell
    }
    
    
    func historyOrdersListener(historyOrders: [OrderLocal]) {
        self.historyOrders = historyOrders
        self.tableView.reloadData()
    }
    
}
