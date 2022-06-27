//
//  CreateUserData.swift
//  PersonRez
//
//  Created by Hồ Sĩ Tuấn on 17/09/2020.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import AVFoundation
import ProgressHUD

class FrameOperation: Operation {
    var time: Double!
    var label: String!
    private var generator:AVAssetImageGenerator!
    
    init(time: Double, label: String, gen: AVAssetImageGenerator) {
        self.time = time
        self.label = label
        self.generator = gen
    }
    
    override func main() {
        getFrame(fromTime: time, for: label)
    }
    
    private func getFrame(fromTime:Double, for label: String) {
        
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 60)
        let image:UIImage
        do {
            try image = UIImage(cgImage: self.generator.copyCGImage(at:time, actualTime:nil))
        } catch {
            return
        }
        Staff.shared.trainingDataset.saveImage(image, for: label)
        if let img = image.rotate(radians: .pi / 20) {
            Staff.shared.trainingDataset.saveImage(img, for: label)
        }
        if let img = image.rotate(radians: -.pi / 20) {
            Staff.shared.trainingDataset.saveImage(img, for: label)
        }
        if let img = image.flipHorizontally() {
            Staff.shared.trainingDataset.saveImage(img, for: label)
        }
    }
}

class GetFrames {
    
    var fps = 2
    private var generator:AVAssetImageGenerator!
    
    func getAllFrames(_ videoUrl: URL, for label: String, whith uuid: String) {
        let asset:AVAsset = AVAsset(url: videoUrl)
        let duration:Double = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        
        var i: Double = 0
        repeat {
            let frameOperation = FrameOperation(time: i, label: label, gen: self.generator)
            queue.addOperation(frameOperation)
            i = i + (1 / Double(self.fps))
        } while (i < duration)
        self.generator = nil
        queue.addBarrierBlock {
            ProgressHUD.show("Generating...")
            Staff.shared.vectorHelper.addVector(name: label, uuid: uuid) { result in
                print("All vectors for \(label): \(result.count)")
                if result.count > 0 {
                    getKMeanVectorSameName(vectors: result) { (vectors) in
            
                        print("K-mean vector for \(label): \(vectors.count)")
                        Staff.shared.fb.uploadKMeanVectors(vectors: vectors, child: AppConstants.KMEAN_VECTOR) {
                            Staff.shared.fb.uploadAllVectors(vectors: result, child: AppConstants.ALL_VECTOR) {
                            }
                        }
                    }
                }
            }
        }
    }
}
