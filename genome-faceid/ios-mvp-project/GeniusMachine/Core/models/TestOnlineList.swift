//
//  TestOnlineList.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation

struct TestOnlineList {
    let user: User
    let testResult: TestResult
    let avatarUrl: String?

    var asDictionary: [String: Any] {
        var result: [String : Any] = [
            "user_uuid": user.uuid,
            "user_name": user.name,
            "type": testResult.type.rawValue,
            "result": testResult.result,
            "timestamp": testResult.date.timeIntervalSince1970,
        ]
        avatarUrl.flatMap {
            result["avatarUrl"] = $0
        }
        return result
    }
}
