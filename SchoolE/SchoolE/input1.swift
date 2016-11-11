//
//  input1.swift
//  SchoolE
//
//  Created by rentsl on 16/11/10.
//  Copyright © 2016年 rentsl. All rights reserved.
//

import UIKit

class input1: UIViewController {

    @IBOutlet weak var input1: UITextField!
    
    @IBOutlet weak var input2: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func button(sender: UIButton) {
        SocketConnect.socket.emit("fadan", input2.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketConnect.socket.on("result") { data,_ in
            self.label.text = String(data)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
