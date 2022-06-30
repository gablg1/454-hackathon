//
//  QrContent.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation

enum QrContentType: Codable {
    case test
    case device
}

struct QrContent: Codable {
    let type: QrContentType
    let test: TestContent?
    let device: DeviceContent?
}

extension QrContent {
    struct TestContent: Codable {
        enum TestType: String, Codable  {
            case covid19 = "Covid19"
            case monkeypox = "Monkeypox"
        }
        var testType: TestType
    }
}

extension QrContent {
    struct DeviceContent: Codable {
        var type = "Genious Machine"
    }
}
