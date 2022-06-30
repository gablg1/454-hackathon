//
//  Define.swift
//  Genius Machine
//
//  Created by Hồ Sĩ Tuấn on 25/09/2020.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation

enum AppConstants {
    static let LOGIN_TABLE = "LoginTable"
    static let LOG_TIME = "LogTimes"
    static let ALL_VECTOR = "all_vectors"
    static let AVG_VECTOR = "Vectors"
    static let KMEAN_VECTOR = "K_mean_Vectors"
    static let USER_CHILD = "Users"
    static let TESTS = "Tests"

    static let STORAGE_URL = "gs://geniousmachine-5aae8.appspot.com"

    //Define unknown
    static let UNKNOWN = "Unknown"
    static let TAKE_PHOTO_NAME = "Unknown - Take Photo"


    static let NUMBER_OF_K = 3

    //RealM
    static let SAVED_USERS = "SavedUserList"

    //Date time formatter
    static let DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let CELL_DATE_FORMAT = "yyyy/MM/dd HH:mm a"

    static let VALID_TIME = 60
    static let FACELOGIN_TIMEOUT: TimeInterval = 5

    static let validFrames = 5
}
