//
//  CountryListViewModel.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import Foundation

class StatisticsListViewModel {
    /// we can inject testable provider here
    var provider: CovidNetworkClientProtocol = CovidNetworkClient()
    var statisticsType: CovidApiEndPoint = .allCountries
    var currentTask: Cancellable?
    var shouldShowShimmer: Bool = false
    var statisticsCellsViewModels: [CovidStatisticsCellViewModel] = []


    init() {
       //loadShimmeringModel()
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
                    self.shouldShowShimmer = false
                    return
            }

            switch self.statisticsType  {
            case .allCountries:
                self.statisticsCellsViewModels = statistics.sorted{ $0.country ?? "" < $1.country ?? "" }
                    .compactMap { $0.mapToViewModel() }

            case .history:
                self.statisticsCellsViewModels = statistics.sorted{ $0.country ?? "" < $1.country ?? "" }
                    .compactMap { $0.mapToHishtoryViewModel() }
            }

            self.shouldShowShimmer = false
            completion?(true)
        }
    }


    func statistics(at index: Int) -> CovidStatisticsCellViewModel {
        return statisticsCellsViewModels[index]
    }


}

//MARK:- shimmiring model loading
extension StatisticsListViewModel {
    func loadShimmeringModel() {
        let filePath = Bundle.main.path(forResource: "forecasts_shimmer_model",
                                        ofType: "json") ?? ""
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath),
                                   options: .alwaysMapped) else { return }
        let decoder = JSONDecoder()
        guard let statistics = try? decoder.decode(CovidStatisticsResponse.self, from: data).statistics  else {return}
        self.statisticsCellsViewModels = statistics.sorted{ $0.country ?? "" < $1.country ?? "" }
            .compactMap { $0.mapToViewModel() }
        self.shouldShowShimmer = true
    }
}
