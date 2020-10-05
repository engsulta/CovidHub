//
//  CovidStatisticsTableViewCell.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import UIKit

class CovidStatisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var numberOfCases: UILabel!
    @IBOutlet weak var numberOfDeaths: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!


    var viewModel: CovidStatisticsCellViewModel? {
        didSet {
            title.text = viewModel?.title
            numberOfCases.text = viewModel?.newCases
            numberOfDeaths.text = viewModel?.newDeath
            numberOfTests.text = viewModel?.dailyTests
            self.layoutIfNeeded()
        }
    }
}
