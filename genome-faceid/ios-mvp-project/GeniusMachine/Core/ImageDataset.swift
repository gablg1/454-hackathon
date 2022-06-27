//
//  ImageDataset.swift
//  PersonRez
//
//  Created by Hồ Sĩ Tuấn on 31/08/2020.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import CoreML

class ImageDataset {
    enum Split {
        case train
        case test
        var folderName: String {
            self == .train ? "train" : "test"
        }
    }
    
    let split: Split
    let smallestSide = 500
    private let baseURL: URL
    
    init(split: Split) {
        self.split = split
        baseURL = applicationDocumentsDirectory.appendingPathComponent(split.folderName)
        createDatasetFolder()
    }
    private func createDatasetFolder() {
        //print("Path for \(split): \(baseURL)")
        createDirectory(at: baseURL)
    }
}

// MARK: - Mutating the dataset

extension ImageDataset {
    
    func saveImage(_ image: UIImage, for label: String) {
        let fileName = UUID().uuidString + ".jpg"
        createDirectory(at: Staff.shared.documentDirectory.appendingPathComponent(split.folderName).appendingPathComponent(label))
        let fileURL = Staff.shared.documentDirectory.appendingPathComponent(split.folderName).appendingPathComponent(label).appendingPathComponent(fileName)

        if let data = image.dataToSave(), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("saved at \(fileURL)")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func getImage(label: String) -> [UIImage?] {
        var imageUrl: [URL] = []
        var imageList:[UIImage] = []
        let url = Staff.shared.documentDirectory.appendingPathComponent(split.folderName).appendingPathComponent(label)
        imageUrl.append(contentsOf: contentsOfDirectory(at: url) { url in
            url.pathExtension == "jpg" || url.pathExtension == "png"
        })
        
        for i in 0..<imageUrl.count
        {
            let image = UIImage(contentsOfFile: imageUrl[i].path)
            imageList.append(image!)
        }
        return imageList
        
    }
}

extension UIImage {
    func dataToSave() -> Data? {
        (resized(smallestSide: 512) ?? self).jpegData(compressionQuality: 0.7)
    }

    private
    func resize() -> UIImage {
        guard size.width > 1024 || size.height > 1024 else {
            return self
        }

        let factor = size.width / size.height
        let newSize = factor > 1.0 ? CGSize(width: 1024, height: 1024 / factor) : CGSize(width: 1024 / factor, height: 1024)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }

    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
