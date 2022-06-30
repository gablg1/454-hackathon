//
//  UserMainView.swift
//  Genius Machine
//
//  Created by Andrei Pachtarou on 24.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

class UserMainView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let rootViewControler = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootViewControler, self]
        }
        navigationItem.setHidesBackButton(true, animated: false);
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    @IBAction func logoutTap(_ sender: UIButton) {
        print("logout")
        navigationController?.popToRootViewController(animated: false)

    }
}
