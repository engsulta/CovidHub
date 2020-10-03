//
//  NetworkHelperProtocols.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//


import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
   
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request,
                        completionHandler: completionHandler) as URLSessionDataTask
    }
}


protocol URLSessionDataTaskProtocol: Cancellable {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}



struct Constants {
    static let baseURL: URL = URL(string: "https://covid-193.p.rapidapi.com")!
    static let headers = ["x-rapidapi-host": "covid-193.p.rapidapi.com",
                          "x-rapidapi-key": "0090b0350dmshe3863790aa23dbfp1758c3jsnce3dde0cb3ba" ]
}

enum NetworkError: String, Error{
    case missingURL = "missing URL"
    case faildToDecode = "unable to decode the response"
    case noNetwork = "unknown"
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key,
                                                        value: "\($0.value)")
        }
    }
}
