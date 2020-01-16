//
//  PhotoCollectionCellViewModel.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import Foundation

class PhotoCollectionCellViewModel:CellViewModel  {
    var identifier:UUID
    var editBtnPressed: (()->Void)?
    var imageUrl:URL
    var title:String
    var searchKey:String
    
    init(photo:Photo, searchKey:String) {
        self.imageUrl = photo.imageUrl
        self.title = photo.title
        self.searchKey = searchKey
        self.identifier = UUID()
    }
    
    init(title:String, imageUrl:URL, searchKey:String, identifier:UUID = UUID()) {
        self.title = title
        self.imageUrl = imageUrl
        self.searchKey = searchKey
        self.identifier = identifier
    }
}

extension PhotoCollectionCellViewModel:Hashable {
    static func == (lhs: PhotoCollectionCellViewModel, rhs: PhotoCollectionCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
