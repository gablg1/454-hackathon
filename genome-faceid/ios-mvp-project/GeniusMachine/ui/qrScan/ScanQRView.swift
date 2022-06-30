//
//  ScanQRView.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 24.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var qrView: UIView!

    var isReadyToCompleted = false
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        switch Staff.shared.appMode {
        case .scanTest: scanTestMode()
        case .family: familyMode()
        case .Hospital: hospitalMode()
        }
    }

    func scanTestMode() {
        let testType: QrContent.TestContent.TestType = Int(Date().timeIntervalSince1970) % 2 == 0 ? .covid19 : .monkeypox
        Staff.shared.qrContent = QrContent(type: .test, test: .init(testType: testType), device: nil)

        showLoginDiaglog(name: testType.rawValue) {
            self.performSegue(withIdentifier: "openFaceLogin", sender: nil)
        }
    }

    func familyMode() {
        let testType: QrContent.TestContent.TestType = Int(Date().timeIntervalSince1970) % 2 == 0 ? .covid19 : .monkeypox
        Staff.shared.qrContent = QrContent(type: .test, test: .init(testType: testType), device: nil)

        showLoginDiaglog(name: testType.rawValue) {
            self.performSegue(withIdentifier: "openFaceLogin", sender: nil)
        }
    }

    func hospitalMode() {
        let testType: QrContent.TestContent.TestType = Int(Date().timeIntervalSince1970) % 2 == 0 ? .covid19 : .monkeypox
        Staff.shared.qrContent = QrContent(type: .test, test: .init(testType: testType), device: nil)

        showLoginDiaglog(name: testType.rawValue) {
            self.performSegue(withIdentifier: "openFaceLogin", sender: nil)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScanQRView {
    func showLoginDiaglog(name: String, callback: @escaping () -> Void) {
        guard !isReadyToCompleted else {
            return
        }
        isReadyToCompleted = true
        let title = "\(name) scanned via QR"
        let alert = UIAlertController(title: title, message: "Scanned from QR", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true, completion: callback)
        }
    }
}
