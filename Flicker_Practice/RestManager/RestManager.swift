//
//  NetworkUtility.swift
//  PhotoDemo
//
//  Created by SHIH-YING PAN on 2019/1/11.
//  Copyright © 2019 SHIH-YING PAN. All rights reserved.
//

import UIKit

class RestManager {
    static let share = RestManager()
    let queue = DispatchQueue(label: "RestManager",qos: .userInitiated)
    
    private init() {}
    
    func makeRequest(_ request:HttpRequest ,completion: @escaping (_ result: Results) -> Void) {
        guard let request = request.value else {
            DispatchQueue.main.async {completion(Results(withError: CustomError.failedToCreateRequest))}
            return
        }
        
        queue.async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {completion(Results(withData: data, response: Response(fromURLResponse: response), error: error))}
            }
            task.resume()
        }
    }
    
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        queue.async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let data = data else { completion(nil); return }
                DispatchQueue.main.async {completion(data)}
            }
            task.resume()
        }
    }
}

extension RestManager {
    enum HttpMethod: String {
        case get
        case post // create new resource
        case put  //update with full resource info
        case patch //update with part of resource info
        case delete
    }
    
    struct RestEntity {
        private var values: [String: String] = [:]
        
        mutating func set(values:[String: String] = [:]) {
            self.values = values
        }
        
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        mutating func removeAlll() {
            values.removeAll()
        }
        
        mutating func removeValue(atKey key:String) {
            values.removeValue(forKey: key)
        }
        
        func value(forKey key: String) -> String? {
            return values[key]
        }
        
        func allValues() -> [String: String] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
    }
    
    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers = RestEntity()
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }
    
    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
}

extension RestManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
