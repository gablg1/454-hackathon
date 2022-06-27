//
//  FirebaseManager+ext.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Nuke

extension FirebaseManager {
    enum Constants {
        static let TestsTable = "tests_table"
        static let TestsOnlineTable = "tests_online_table"
    }

    func loadTests(user: User) async -> [TestResult] {
        return await withCheckedContinuation { [weak self] continuation in
            database
                .reference()
                .child(Constants.TestsTable)
                .child(user.uuid)                
                .queryLimited(toLast: 10)
                .observeSingleEvent(
                    of: .value,
                    with:{ snapshot in
                        var handled = [TestResult]()
                        guard
                            let list = snapshot.value as? [String: Any]
                        else {
                            continuation.resume(returning: [])
                            return
                        }
                        handled = list.keys.sorted()
                            .compactMap { list[$0] as? [String : Any] }
                            .compactMap { TestResult(from: $0) }
                        continuation.resume(returning: handled)
                    }
                ) { [weak self] error in
                    self?.logger.error("\(error)")
                    continuation.resume(returning: [])
                }
        }
    }

    func add(newTest: TestResult, for user: User) async {
        let avatarUrl = await upload(image: user.image, for: user)
        await add(newTest: newTest, avatarUrl: avatarUrl, for: user)
        await addToOnlineList(newTest: newTest, avatarUrl: avatarUrl, for: user)
    }

    func add(newTest: TestResult, avatarUrl: URL?, for user: User) async {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume()
                return
            }

            let remoteTest = RemoteTestResult(user: user,
                                              testResult: newTest,
                                              avatarUrl: avatarUrl?.absoluteString)

            self.database
                .reference()
                .child(Constants.TestsTable)
                .child(user.uuid)
                .child("\(Int(newTest.date.timeIntervalSince1970))")
                .updateChildValues(remoteTest.asDictionary) { [weak self] error, ref in
                    error.flatMap { self?.logger.error("\($0)") }
                    continuation.resume()
                }
        }
    }

    func addToOnlineList(newTest: TestResult, avatarUrl: URL?, for user: User) async {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume()
                return
            }
            let onlineTest = TestOnlineList(user: user,
                                            testResult: newTest,
                                            avatarUrl: avatarUrl?.absoluteString)
            self.database.reference()
                .child(Constants.TestsOnlineTable)
                .child("\(Int(newTest.date.timeIntervalSince1970 * 10000))")
                .updateChildValues(onlineTest.asDictionary) {
                    [weak self] error, ref in
                        error.flatMap { self?.logger.error("\($0)") }
                        continuation.resume()
                }
            }
    }

    func upload(image: UIImage, for user: User) async -> URL? {
        return await withCheckedContinuation { continuation in
            let storageRef = Storage.storage(url: AppConstants.STORAGE_URL).reference().child("\(user.name) - \(user.time.dropLast(10))")

            guard let imageData = user.image.dataToSave() else {
                continuation.resume(returning: nil)
                return
            }

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageRef.putData(imageData,metadata: metadata) { metadata, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    continuation.resume(returning: nil)
                    return
                }

                storageRef.downloadURL{ url, error in
                    guard let url = url else {
                        continuation.resume(returning: nil)
                        return
                    }
                    continuation.resume(returning: url)
                }
            }
        }
    }
}
