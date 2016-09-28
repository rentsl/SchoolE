//
//  MyGetOrder+CoreDataProperties.swift
//  SchoolE
//
//  Created by rentsl on 16/9/10.
//  Copyright © 2016年 rentsl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyGetOrder {

    @NSManaged var userTel: String?
    @NSManaged var userName: String?
    @NSManaged var userImage: NSData?
    @NSManaged var time: String?
    @NSManaged var orderState: String?
    @NSManaged var money: String?
    @NSManaged var location: String?
    @NSManaged var getUser: String?
    @NSManaged var detail: String?

}
