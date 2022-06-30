//
//  TestsView.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit
import AVFoundation
import ProgressHUD

class TestsView: UIViewController {
    enum Constants {
        static let cellID = "TestCell"
    }

    var user: User { Staff.shared.currentUser! }
    var scannedQrContent: QrContent? { Staff.shared.qrContent }
    var appFb: FirebaseManager { Staff.shared.fb }

    let speaker = Speaker()

    @IBOutlet weak var tableView: UITableView!
    var name = ""
    var tests: [TestResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let rootViewControler = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootViewControler, self]
        }
        navigationItem.setHidesBackButton(true, animated: false);

        self.title = "Your tests:"
        tableView.delegate = self
        tableView.dataSource = self

        if let qr = scannedQrContent {
            makeNewTestScenario(qr: qr)
        }

        loadTests()
    }

    @IBAction func logoutTap(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }

    func makeNewTestScenario(qr: QrContent) {
        Task {
            await gmBecomeReady()
            await gmWaitingYourTest()
            await gmCatchYourTestAndStartProcessing()
            await gmComplete(qr: qr)
        }
    }
}

extension TestsView {
    func reload(newTests: [TestResult]) {
        DispatchQueue.main.async {
            self.tests = newTests
            self.tableView.reloadData()
        }
    }

    func loadTests() {
        Task {
            let stored = await self.appFb.loadTests(user: user)
            self.reload(newTests: stored)
        }
    }
}

extension TestsView {
    func gmBecomeReady() async {
        await msg("Hi \(user.name)!")
        try? await Task.sleep(nanoseconds: 300_000_000)
    }

    func gmWaitingYourTest() async {
        await msg("All is ready! You can make test and put it into Genious Machine.")
    }

    func gmCatchYourTestAndStartProcessing() async {
        await msg("Awesome! I caught it and need time for processing.")
    }

    func gmComplete(qr: QrContent) async {
        let result = Int(Date().timeIntervalSince1970) % 2 == 0
        let newTest = TestResult(type: qr.test!.testType, date: Date(), result: result)

        //push test to server
        await appFb.add(newTest: newTest, for: self.user)

        //show message to user
        await msg("Your test is ready. Please check it!")

        ProgressHUD.dismiss()

        var updatedTests = tests
        updatedTests.insert(newTest, at: 0)
        reload(newTests: updatedTests)
    }

    func msg( _ msg: String) async {
        DispatchQueue.main.async {
            ProgressHUD.show(msg)
        }
        await speaker.speak(msg)
    }
}

extension TestsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) as? TestCell else {
            return UITableViewCell()
        }
        cell.update(with: tests[indexPath.row])
        return cell
    }
}
