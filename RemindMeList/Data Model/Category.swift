//
//  Category.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 20/02/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
