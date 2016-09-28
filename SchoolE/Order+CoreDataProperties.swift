//
//  Order+CoreDataProperties.swift
//  SchoolE
//
//  Created by rentsl on 16/7/30.
//  Copyright © 2016年 rentsl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Order {

    @NSManaged var location: String?
    @NSManaged var detail: String?
    @NSManaged var time: String?
    @NSManaged var userName: String?
    @NSManaged var userImage: NSData?
    @NSManaged var orderState: String?
    @NSManaged var money: String?
    @NSManaged var userTel: String?
    @NSManaged var getUser: String?

}
