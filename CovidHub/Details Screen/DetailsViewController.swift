//
//  DetailsViewController.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/4/20.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var showHistoryButton: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var numberOfCases: UILabel!
    @IBOutlet weak var numberOfDeaths: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalOfCases: UILabel!
    @IBOutlet weak var totalOfDeaths: UILabel!
    var statisticsType:CovidApiEndPoint = .allCountries
    var viewModel: CovidStatisticsCellViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        configure()
    }

    func configure() {
        date.text = viewModel?.title
        numberOfCases.text = viewModel?.newCases
        numberOfDeaths.text = viewModel?.newDeath
        numberOfTests.text = viewModel?.dailyTests
        totalOfCases.text = viewModel?.totalCases
        totalOfDeaths.text = viewModel?.totalDeath
        guard statisticsType != .allCountries else { return }
        showHistoryButton.isEnabled = false
        showHistoryButton.alpha = 0

    }

    
    @IBAction func openHistoryStatistics(_ sender: Any) {
        let statisticsList = UIStoryboard(name: "Countries", bundle: nil).instantiateViewController(withIdentifier: "StatisticsListViewController") as! StatisticsListViewController
        statisticsList.viewModel.statisticsType = .history(country: viewModel?.title ?? "", day: nil)
        navigationController?.pushViewController(statisticsList, animated: true)
    }

    func setupNav() {
        title = viewModel?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareData))
    }

    @objc func shareData() {
        // will be formatted
        let sharableText = "today updates for \(viewModel?.title ?? "") , no of cases: \(viewModel?.newCases ?? "") , no of deaths: \(viewModel?.newDeath ?? "") "
        let ac = UIActivityViewController(activityItems: [sharableText], applicationActivities: nil)
        present(ac, animated: true)
    }
}
