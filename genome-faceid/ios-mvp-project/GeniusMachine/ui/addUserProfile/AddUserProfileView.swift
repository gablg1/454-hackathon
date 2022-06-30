//
//  AddUserProfileView.swift
//  Genius Machine
//
//  Created by Andrei Pachtarou on 24.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit
import AVFoundation
import SkyFloatingLabelTextField
import MBProgressHUD
import ProgressHUD

class AddUserProfileView: UIViewController {

    private var generator:AVAssetImageGenerator!

    @IBOutlet weak var idTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    var videoURL: URL?
    var loginComplete = false
    private let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        Staff.shared.fnet.load()
        faceImageView.layer.cornerRadius = faceImageView.frame.height / 2
        if let url = videoURL {
            self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                self.faceImageView.image = thumbImage
                self.faceImageView.layer.cornerRadius = self.faceImageView.frame.height / 2                
            }
        }
        hideKeyboardWhenTappedAround()

    }

    @IBAction func tapDoneButoon(_ sender: UIButton) {
        guard !loginComplete else {
            return
        }

        if textField.text != "" && videoURL != nil && idTextField.text != "" {
            guard let user_id = Int(idTextField.text!) else {
                showDialog(message: "ID is only number!")
                return
            }
            ProgressHUD.show("Adding...")
            let getFrames = GetFrames()
            print("Your Name is: \(textField.text!)")

            formatter.dateFormat = AppConstants.DATE_FORMAT
            let timestamp = formatter.string(from: Date())
            let user = User(uuid: UUID().uuidString,
                            name: self.textField.text!,
                            image: self.faceImageView.image!,
                            time: timestamp)
            Staff.shared.currentUser = user

            loginComplete = true

            Staff.shared.fb.uploadUser(name: textField.text!,
                          user_id: user_id,
                          uuid: user.uuid) {
                Staff.shared.fb.login(user: user) { [weak self] error in
                    ProgressHUD.dismiss()
                    if let error = error {
                        print("\(error)")
                        self?.loginComplete = false
                    } else {
                        self?.login()
                    }
                }
            }

            //saved to local data
            Staff.shared.savedUserList.append(textField.text!)
            Staff.shared.defaults.set(Staff.shared.savedUserList, forKey: AppConstants.SAVED_USERS)

            getFrames.getAllFrames(videoURL!, for: textField.text!, whith: user.uuid)
        }
        else {
            self.showDialog(message: "Please fill User ID and Name!")
        }
    }

    func login() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Staff.shared.appMode.mainModeRoute, sender: nil)
        }
    }

    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}



