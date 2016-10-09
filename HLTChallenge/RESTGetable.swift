//
//  Downloadable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - RESTGetable Protocol

protocol RESTGetable: Equatable, ResultRepresentable {
    static var urlQueryParameters:   URLParameters { get }
    static var urlAddressParameters: URLParameters { get }
    
    static func create(from dictionary: JSONDictionary) -> Result<Self>
//    static func extract(from: JSONDictionary) -> Result<[Self]>
}

// MARK: - Module Static `urlAddressParameters` Keys

extension RESTGetable {
    static var scheme: String { return "scheme" }
    static var host:   String { return "host" }
    static var path:   String { return "path" }
}

// MARK: - Module Static API

extension RESTGetable {
    static func get(withBlock block: @escaping (Result<Self>) -> Void) {
        switch url() >>= urlRequest { // FIXME: GIT RID OF THIS SWITCH STATEMENT
        case let .error(error):   block <^> Result(error)
        case let .value(request): dataTask(request: request, withBlock: block)
        }
    }
    
    // MARK: Data Processing
    
    static func processDataTask(date: Data?, response: URLResponse?, error: Error?) -> Result<JSONDictionary> {
        return (Result(error, Response(data: date, urlResponse: response)) >>= parse(response:)) >>= decode(json:)
    }
    
    // MARK: URL Configuration
    
    static func urlRequest(from url: URL) -> Result<URLRequest> {
        return curry(Result.init) <^> URLRequest(url: url)
    }
    
    static func url() -> Result<URL> {
        guard let compontentsPath = urlAddressParameters[path] else { return curry(Result.init) <^> URLRequestError.invalidURLPath(path: urlAddressParameters[path]) }
        
        var components        = URLComponents()
        components.path       = compontentsPath
        components.scheme     = urlAddressParameters[scheme]
        components.host       = urlAddressParameters[host]
        components.queryItems = urlQueryParameters.map(URLQueryItem.init)
        
        return components.url.toResult(withError:) <^> URLRequestError.invalidURL(parameters: urlQueryParameters)
    }
}

// MARK: - Fileprivate Static API

extension RESTGetable {
    static fileprivate func dataTask(request: URLRequest, withBlock block: @escaping (Result<Self>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                block <^> (processDataTask(date: data, response: response, error: error) >>= Self.create)
            }
        }.resume()
    }
    
    static fileprivate func parse(response: Response) -> Result<Data> {
        return Response.successRange.contains(response.statusCode) ? Result(response.data) : curry(Result.init) <^> URLRequestError.invalidResponseStatus(code: response.statusCode)
    }
    
    static fileprivate func decode(json data: Data) -> Result<JSONDictionary> {
        do    { return (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONDictionary).toResult(withError:) <^> URLRequestError.couldNotParseJSON }
        catch { return Result(error) }
    }
}
