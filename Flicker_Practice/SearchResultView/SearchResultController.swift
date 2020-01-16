//
//  SearchResultController.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import Foundation

class SearchResultController {
    var viewModel = SearchResultViewModel()
    var searchKey:String?
    var searchAmount:String?
    private var flicker = FlickerAPI()
    
    func start() {
        guard let key = searchKey, let amount = searchAmount else {return}
        viewModel.isLoading.value = true
        flicker.getPhoto(withKeyValue: key, amountOfResult: amount) {[weak self] (photos) in
            guard let self = self else {return}
            self.viewModel.photoCellVMs.value = photos.map() {self.convertPhotoToCellVM(searchKey: key, photo: $0) }
            self.viewModel.isLoading.value = false
        }
    }
}

extension SearchResultController{
    func convertPhotoToCellVM(searchKey key :String, photo:Photo) -> PhotoCollectionCellViewModel {
        let photoCellVM = PhotoCollectionCellViewModel(photo: photo, searchKey: key)
        photoCellVM.editBtnPressed = {
            CoreDataManager.share.createData(photoCellVM: photoCellVM)
        }
        return photoCellVM
    }
}
