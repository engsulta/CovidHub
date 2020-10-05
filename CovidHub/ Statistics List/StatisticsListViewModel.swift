//
//  CountryListViewModel.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import Foundation

class StatisticsListViewModel {
    var provider: CovidNetworkClientProtocol = CovidNetworkClient()
    var statisticsType: CovidApiEndPoint = .allCountries
    var reloadTableClosure: (()-> Void)?
    var currentTask: Cancellable?

    var searchText: String = "" {
        didSet{
            guard !searchText.isEmpty else { filteredStatisticsVM = statisticsCellsViewModels; return }
            filteredStatisticsVM = statisticsCellsViewModels.filter {
                ($0.title?.contains(searchText) ?? false)
            }}
    }

    var statisticsCellsViewModels: [CovidStatisticsCellViewModel] = [] {
        didSet {
            filteredStatisticsVM = statisticsCellsViewModels
        }
    }

    var filteredStatisticsVM: [CovidStatisticsCellViewModel] = [] {
        didSet {
            reloadTableClosure?()
        }
    }

    func fetchStatistics(completion: ((Bool)-> Void)?) {
        currentTask = nil
        currentTask = provider.fetch(endPoint: statisticsType, model: CovidStatisticsResponse.self) { [weak self] (model, error) in

            guard let self = self else {
                return
            }

            guard error == nil,
                  let statistics = (model as? CovidStatisticsResponse)?.statistics else {
                    completion?(false)
                    return
            }

            switch self.statisticsType  {
            case .allCountries:

                self.statisticsCellsViewModels = statistics.filter{$0.continent != $0.country}.sorted{ $0.country ?? "" < $1.country ?? "" }
                    .compactMap { $0.mapToViewModel() }

            case .history:
                self.statisticsCellsViewModels = statistics.compactMap { $0.mapToHishtoryViewModel() }
            }

            completion?(true)
        }
    }

    func statistics(at index: Int) -> CovidStatisticsCellViewModel {
        return filteredStatisticsVM[index]
    }
}
