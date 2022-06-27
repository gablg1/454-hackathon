//
//  TestResult.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation

struct TestResult: Codable {
    let type: QrContent.TestContent.TestType
    let date: Date
    let result: Bool

    init(type: QrContent.TestContent.TestType, date: Date, result: Bool) {
        self.type = type
        self.date = date
        self.result = result
    }

    init?(from dictionary: [String: Any]) {
        guard
            let typeString = dictionary["type"] as? String,
            let type = QrContent.TestContent.TestType.init(rawValue: typeString),
            let timestamp = (dictionary["timestamp"] as? Double),
            let result = dictionary["result"] as? Bool
        else {
            return nil
        }

        self.type = type
        self.date = Date(timeIntervalSince1970: timestamp)
        self.result = result
    }

    var asDictionary: [String: Any] {
        return [
            "type": type,
            "date": date,
            "result": result,
            "timestamp": date.timeIntervalSince1970,
        ]
    }
}
