//
//  CountryListViewController.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import UIKit


// This VC will be used for countries and history
class StatisticsListViewController: UITableViewController {
    var viewModel: StatisticsListViewModel = StatisticsListViewModel()
    let statisticsTableCellId = "CovidStatisticsTableViewCell"
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.setDefaultSearchBar()
        searchController.searchBar.delegate = self
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
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
        viewModel.reloadTableClosure = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func handleFailure() {
        tableView.refreshControl?.endRefreshing()
    }

    func handleSucess() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func setupNav() {
        switch viewModel.statisticsType {
        case .allCountries:
            title = "AllCountries".localized()
        case let .history(country, day):
            title = String(format: "historyTitle".localized(), country)
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK:- Pull to refresh
extension StatisticsListViewController {
    @objc func pullToRefreshHandler() {
        initVM()
    }
}

//MARK:- table view datasource
extension StatisticsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStatisticsVM.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: statisticsTableCellId, for: indexPath) as? CovidStatisticsTableViewCell else { return UITableViewCell()}
        cell.isShimmeringRunning = viewModel.shouldShowShimmer
        cell.viewModel = viewModel.statistics(at: indexPath.row)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard(name: "Countries", bundle: nil).instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsVC.viewModel = viewModel.statistics(at: indexPath.row)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

//MARK:- SearchBarDelegate
extension StatisticsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
        viewModel.searchText = ""
    }
}

extension UISearchController {
    public func setDefaultSearchBar() {
       searchBar.barStyle = .default
       obscuresBackgroundDuringPresentation = false
       hidesNavigationBarDuringPresentation = true
       searchBar.searchBarStyle = .minimal
       definesPresentationContext = true
    }
}
