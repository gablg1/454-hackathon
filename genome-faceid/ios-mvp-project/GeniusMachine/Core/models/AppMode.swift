//
//  AppMode.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation

enum AppMode: String {
    case scanTest
    case family
    case Hospital

    var mainModeRoute: String {
        switch self {
        case .family: return "showUserMainScreen"
        case .Hospital: return "showUserMainScreen"
        case .scanTest: return "testsScreen"
        }
    }
}
