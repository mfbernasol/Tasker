//
//  Item.swift
//  Tasker
//
//  Created by Michael Bernasol on 8/29/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
   
}
