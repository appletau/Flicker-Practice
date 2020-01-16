//
//  HttpRequestURL.swift
//  PhotoDemo
//
//  Created by tautau on 2020/1/13.
//  Copyright © 2020 SHIH-YING PAN. All rights reserved.
//

import Foundation

struct HttpRequest {
    var url:URL
    var method:HttpMethod
    var requestHttpHeaders: [String:String]  // releated to request
    var urlQueryParameters: [String:String]  // query related to url
    var httpBodyParameters: [String:String]  //related to resource which your accseesing,ex: post something to url
    
    var value:URLRequest? {
        let newUrl = self.addURLQueryParameters(toURL: url)
        let httpBody = self.getHttpBody()
        return self.prepareRequest(withURL: newUrl, httpBody: httpBody)
    }
    
    init(url:URL,
         method:HttpMethod,
         header:[String:String] = [:],
         queryParams:[String:String] = [:],
         bodyParams:[String:String] = [:]){
        self.url = url
        self.method = method
        self.requestHttpHeaders = header
        self.urlQueryParameters = queryParams
        self.httpBodyParameters = bodyParams
    }
}

extension HttpRequest {
    
    enum HttpMethod:String{
        case get
        case post // create new resource
        case put  //update with full resource info
        case patch //update with part of resource info
        case delete
    }
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.count > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders["Content-Type"] else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters, options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return nil
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for (header, value) in requestHttpHeaders {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}

