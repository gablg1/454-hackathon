//
//  HomeViewController.swift
//  PersonRez
//
//  Created by Hồ Sĩ Tuấn on 09/09/2020.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import ProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var vectorsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if !NetworkChecker.isConnectedToInternet {
            showDialog(message: "You have not connected to internet. Using local data.")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Staff.shared.resetAppState()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
        Staff.shared.fnet.load()
    }

    @IBAction func tapQrScan(_ sender: UIButton) {
        self.performSegue(withIdentifier: "scanQr", sender: nil)
    }
    @IBAction func tapStart(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openFaceLogin", sender: nil)
    }

    func loadData() {
        if NetworkChecker.isConnectedToInternet {
            ProgressHUD.show("Initialization..")
            Staff.shared.fb.loadVector { [self] (result) in
                Staff.shared.kMeanVectors = result
                print("Number of k-Means vectors: \(Staff.shared.kMeanVectors.count)")
                vectorsLabel.text = "You have \(Staff.shared.kMeanVectors.count / AppConstants.NUMBER_OF_K) users."
                //tree = KDTree(values: kMeanVectors)
                ProgressHUD.dismiss()
                
                //save to local data
                try! Staff.shared.realm.write {
                    Staff.shared.realm.deleteAll()
                }
                for vector in Staff.shared.kMeanVectors {
                    Staff.shared.vectorHelper.saveVector(vector)
                }
            }
            
            Staff.shared.fb.loadUsers(completionHandler: { (result) in
                print("Number of users: \(result.count)")
                ProgressHUD.dismiss()
            })
            
        }
        else {
            //for local data
            let result = Staff.shared.realm.objects(SavedVector.self)
            print(result.count)
            Staff.shared.kMeanVectors = []
            for vector in result {
                let v = Vector(uuid: vector.uuid, name: vector.name, vector: vector.vector.map { $0 }, distance: vector.distance)
                Staff.shared.kMeanVectors.append(v)
            }
            vectorsLabel.text = "You have \(Staff.shared.kMeanVectors.count / AppConstants.NUMBER_OF_K) users."
        }
    }
    
}

