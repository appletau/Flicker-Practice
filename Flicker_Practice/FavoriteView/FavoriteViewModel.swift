//
//  FavoriteViewModel.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import Foundation

class FavoriteViewModel {
    var isLoading = Observable(value: false)
    var sections = Observable<[String:[PhotoCollectionCellViewModel]]>(value: [:])
}
