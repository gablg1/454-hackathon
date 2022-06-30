//
//  SavedVector.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import RealmSwift

class SavedVector: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var uuid: String = ""
    var vector = List<Double>()
    @objc dynamic var distance: Double = 0
}
