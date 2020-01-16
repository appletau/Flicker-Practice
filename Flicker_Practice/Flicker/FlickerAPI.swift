//
//  File.swift
//  PhotoDemo
//
//  Created by tautau on 2020/1/13.
//  Copyright © 2020 SHIH-YING PAN. All rights reserved.
//

import Foundation

struct FlickerAPI {
    var url: URL? = URL(string: "https://api.flickr.com/services/rest/")
    var apiKey = "51adeca3a9cfc2fa1719fb8b33daa0b0"
    
    func getPhoto(withKeyValue key:String, amountOfResult amount:String, then: @escaping (_ photos: [Photo]) -> Void) {
        
        let queryParams: [String : String] = ["method":"flickr.photos.search",
                                                     "api_key":apiKey,
                                                     "text":key,
                                                     "per_page":amount,
                                                     "format":"json",
                                                     "nojsoncallback":"1"]
        let httpRequest = HttpRequest(url: url!, method: .get, queryParams: queryParams)
        
        RestManager.share.makeRequest(httpRequest) { (results) in
            
            if let data = results.data, let searchData = try? JSONDecoder().decode(SearchData.self, from: data) {
                then(searchData.photos.photo)
            }else {
                print(results.error!.localizedDescription)
            }
        }
    }
}

