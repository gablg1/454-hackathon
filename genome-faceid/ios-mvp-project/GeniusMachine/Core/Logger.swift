//
//  Logger.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation

class Logger {
    let isEnabled: Bool
    let prefix: String

    init(isEnabled: Bool, prefix: String) {
        self.isEnabled = isEnabled
        self.prefix = prefix
    }

    func error(_ msg: String) {
        print(msg)
    }
}
