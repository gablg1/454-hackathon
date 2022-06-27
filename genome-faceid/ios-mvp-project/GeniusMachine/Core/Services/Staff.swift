//
//  Staff.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit
import CoreML
import RealmSwift

class Staff {
    static let shared = Staff()

    //Machine Learning Model
    let fnet = FaceNet()
    let fDetector = FaceDetector()

    var vectorHelper = VectorHelper()

    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let trainingDataset = ImageDataset(split: .train)
    let testingDataset = ImageDataset(split: .test)

    let validFrames = 5 //after getting 5 frames, users have been verified

    var attendList: [Users] = [] //load from firebase
    var localUserList: [User] = [] //copy of attenList, use it to ignore appended users

    //Save User Local List
    let defaults = UserDefaults.standard
    var savedUserList = UserDefaults.standard.stringArray(forKey: AppConstants.SAVED_USERS) ?? [String]()


    //Realm
    let realm = try! Realm()
    let fb  = FirebaseManager()

    //KMeans to reduce number  of vectors
    let KMeans = KMeansSwift.sharedInstance
    var kMeanVectors = [Vector]()

    var current: CGImage?
    var currentUser: User?
    var qrContent: QrContent?
    var appMode: AppMode = .scanTest

    func resetAppState() {
        Staff.shared.fnet.clean()
        qrContent = nil
        currentUser = nil
    }
}
