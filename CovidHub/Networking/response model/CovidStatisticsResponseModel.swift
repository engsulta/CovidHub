//
//  CovidStatisticsResponseModel.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import Foundation

struct CovidStatisticsResponse : Codable {

    let statistics : [CovidStatisticsResponseModel]?
    enum CodingKeys: String, CodingKey {
        case statistics = "response"
    }
}

struct CovidStatisticsResponseModel : Codable {

    let cases : Case?
    let country : String?
    let day : String?
    let deaths : Death?
    let tests : Test?
    let continent: String?


    enum CodingKeys: String, CodingKey {
        case cases
        case country = "country"
        case day = "day"
        case deaths
        case tests
        case continent
    }

    func mapToViewModel() -> CovidStatisticsCellViewModel {

        let viewModel = CovidStatisticsCellViewModel(title: country,
                                                     dailyTests: "\(tests?.total ?? 0)",
                                                     newCases: cases?.new,
                                                     newDeath: deaths?.new,
                                                     totalCases: "\(cases?.total ?? 0)",
                                                     totalDeath: "\(deaths?.total ?? 0)")
        return viewModel
    }

    func mapToHishtoryViewModel() -> CovidStatisticsCellViewModel {
        let viewModel = CovidStatisticsCellViewModel(title: day,
                                                     dailyTests: "\(tests?.total ?? 0)",
                                                     newCases: cases?.new,
                                                     newDeath: deaths?.new,
                                                     totalCases: "\(cases?.total ?? 0)",
                                                     totalDeath: "\(deaths?.total ?? 0)")
        return viewModel
    }
}


struct Death : Codable {
    let new : String?
    let total : Int?

    enum CodingKeys: String, CodingKey {
        case new = "new"
        case total = "total"
    }
}

struct Test : Codable {
    let total : Int?
    enum CodingKeys: String, CodingKey {
        case total = "total"
    }
}

struct Case : Codable {

    let active : Int?
    let critical : Int?
    let new : String?
    let recovered : Int?
    let total : Int?


    enum CodingKeys: String, CodingKey {
        case active = "active"
        case critical = "critical"
        case new = "new"
        case recovered = "recovered"
        case total = "total"
    }
}

struct Countries : Codable {
    let list : [String]?
    enum CodingKeys: String, CodingKey {
        case list = "response"
    }
}
