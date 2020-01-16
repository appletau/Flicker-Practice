//
//  SearchResultViewModel.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import Foundation

class SearchResultViewModel {
    var isLoading = Observable(value: false)
    var photoCellVMs = Observable<[PhotoCollectionCellViewModel]>(value: [])
}
