//
//  TestCell.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    let formatter = DateFormatter()
    @IBOutlet weak var testContent: UIView!
    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var testDate: UILabel!
    @IBOutlet weak var testResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        testContent.layer.cornerRadius = 6
        testContent.layer.borderWidth = 1
        testContent.layer.borderColor = UIColor.lightGray.cgColor
    }

    func update(with result: TestResult) {
        testName.text = result.type.rawValue
        formatter.dateFormat = AppConstants.CELL_DATE_FORMAT
        testDate.text = formatter.string(from: result.date)

        testResult.text = result.result ? "POSITIVE" : "NEGATIVE"
        testResult.textColor = result.result ? .red : .green
    }
}
