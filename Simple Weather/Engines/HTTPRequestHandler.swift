//
//  HTTPRequestHandler.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

// Declairing a class here to provide a namespace to place http helper functions.

class HTTPRequestHandler {
    static let weatherServiceTimeout: Double = 30
    
    // Create a data structure to standardize how http responses are passed around the app
    struct HTTPRequestResponse {
        let response: URLResponse?
        let data: Data?
        let error: Error?
        var statusCode: Int {
            return (response as? HTTPURLResponse)?.statusCode ?? 0
        }
        
        init(_ response: URLResponse?, _ data: Data?, _ error: Error?) {
            self.response = response
            self.data = data
            self.error = error
        }
    }
    
    // Callback based call. May add async/await as app evolves
    static func performRequest(_ request: URLRequest, callback: @escaping(HTTPRequestResponse)->Void ) {
        URLSession.shared.dataTask(with: request, completionHandler: { [callback] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            callback(HTTPRequestResponse.init(urlResponse, data, error))
        }).resume()
    }
    
    // Request builder function which makes sure the api key is present and will make all the necessary settings
    static func weatherRequestBuilder(base: String, parameters: [String : String]?) -> URLRequest? {
        var urlBuilder = URL.init(string: base)
        
        if urlBuilder == nil { return nil };
        
        var parameterArray:[URLQueryItem] = []
        if let parameters {
            for key in parameters.keys {
                parameterArray.append(URLQueryItem.init(name: key, value: parameters[key]))
            }
        }
        parameterArray.append(URLQueryItem.init(name: "appid", value: weatherAPIKey))
        urlBuilder?.append(queryItems: parameterArray)

        guard let urlBuilder else { return nil }
        return URLRequest.init(url: urlBuilder, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: weatherServiceTimeout)
    }
    
}
