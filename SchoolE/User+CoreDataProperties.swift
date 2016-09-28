//
//  User+CoreDataProperties.swift
//  SchoolE
//
//  Created by rentsl on 16/8/5.
//  Copyright © 2016年 rentsl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userName: String?
    @NSManaged var userImage: NSData?
    @NSManaged var userTel: String?
    @NSManaged var password: String?
    @NSManaged var school: String?
    @NSManaged var name: String?
    @NSManaged var studentID: String?
    @NSManaged var paynumber: String?

}
