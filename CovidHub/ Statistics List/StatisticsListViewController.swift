//
//  CountryListViewController.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import UIKit


class StatisticsListViewController: UITableViewController {
    var viewModel: CountryListViewModel = CountryListViewModel()
    let statisticsTableCellId = "CovidStatisticsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitle()
        setupTableView()
        initVM()
    }

    func setupTableView() {
        tableView.refreshControl =  UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.systemGray
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshHandler), for: .valueChanged)
        let forecastTableCell = UINib(nibName: statisticsTableCellId, bundle: Bundle.main)
        tableView.register(forecastTableCell,
                           forCellReuseIdentifier: statisticsTableCellId)
    }

    /// start initialize view model
    func initVM(completion: (() -> Void)? = nil) {
        viewModel.fetchStatistics { [weak self] success in
            guard let self = self else { return }
            guard success else {
                self.handleFailure()
                return
            }
            self.handleSucess()
            completion?()
        }
    }

    func handleFailure() {
        tableView.refreshControl?.endRefreshing()
    }

    func handleSucess() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func setupNavTitle() {
        switch viewModel.statisticsType {
        case .allCountries:
            title = "All Countries"
        case let .history(country, day):
            title = "History for \(country) in \(day)"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}


//MARK:- table view datasource
extension StatisticsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.statisticsCellsViewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: statisticsTableCellId, for: indexPath) as? CovidStatisticsTableViewCell else { return UITableViewCell()}
        cell.isShimmeringRunning = viewModel.shouldShowShimmer
        cell.statisticsVM = viewModel.statistics(at: indexPath.row)
        return cell
    }
}

// Pull to refresh
extension StatisticsListViewController {
    @objc func pullToRefreshHandler() {
        initVM()
    }
}

