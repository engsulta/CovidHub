//
//  CovidNetworkClient.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//


import Foundation
typealias NetworkCompletion = ( _ response: Decodable?,_ error: NetworkError?) -> Void

/// protocol for the Covid api client
protocol CovidNetworkClientProtocol {
    var session: URLSessionProtocol { get }
    @discardableResult
    func fetch<T:Decodable>(endPoint: CovidApiEndPoint, model: T.Type, completion: @escaping NetworkCompletion) -> Cancellable?
}

/// concrete implementation for the Covid client protocol
class CovidNetworkClient: CovidNetworkClientProtocol {
    var session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

//MARK:- fetch implementation
extension CovidNetworkClient {
    @discardableResult
    func fetch<T:Decodable>(endPoint: CovidApiEndPoint,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable? {

        guard let url = endPoint.url else {
            DispatchQueue.main.async {
                completion(nil, NetworkError.missingURL)
            }
            return nil
        }
        let currentTask = session.dataTask(with: url,
                                           completionHandler: { (data, response, error) in
                                            guard let jsonData = data else {
                                                DispatchQueue.main.async { completion(nil, NetworkError.noNetwork) }
                                                return}
                                            do {
                                                let responseModel = try JSONDecoder().decode(model, from: jsonData)
                                                print(responseModel)

                                                DispatchQueue.main.async {
                                                    completion(responseModel, nil)
                                                }
                                            } catch {
                                                DispatchQueue.main.async {
                                                    completion(nil, NetworkError.faildToDecode)
                                                }
                                            }
                                           })

        currentTask.resume()
        return currentTask
    }
}

/// Covid End-point simple representation for custom url request builder
enum CovidApiEndPoint: Equatable {
    case countries
    case statistics(day: String)
    case history(country: String, day: String)


    var path: String {
        switch self {

        case .countries:
            return "/countries"
        case .statistics:
            return "/statistics"
        case .history:
            return "/history"
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .history(country, day):
            return ["day": day, "country": country]
        default:
            return nil
        }
    }

    var url: URLRequest? {
        let url = Constants.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers

        // add parameters for history request
        switch self {
        case .history:
            guard var urlComponents = URLComponents(url: url,
                                                    resolvingAgainstBaseURL: false) else { return nil }
            urlComponents.setQueryItems(with: parameters ?? [:])
            request.url = urlComponents.url
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        default:
            break
        }
        return request
    }
}

protocol Cancellable {
    func cancel()
}
