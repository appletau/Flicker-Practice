//
//  FavoriteController.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import Foundation
import CoreData

class FavoriteController {
    var viewModel = FavoriteViewModel()
    
    func start() {
        getFavotite()
    }
}

extension FavoriteController {
    
    func getFavotite() {
        viewModel.isLoading.value = true
        CoreDataManager.share.retrieveData{
            guard let result = $0 else {return}
            self.viewModel.sections.value = self.convertToSections(result: result)
            self.viewModel.isLoading.value = false
        }
    }
}

extension FavoriteController {
    private func convertToSections(result:[NSManagedObject]) -> [String:[PhotoCollectionCellViewModel]] {
        var sections:[String:[PhotoCollectionCellViewModel]] = [:]
        for data in result {
            let searchKey = data.value(forKey: "searchKey") as! String
            let photoCellVM = PhotoCollectionCellViewModel(title:data.value(forKey: "title") as! String,
                                                           imageUrl: data.value(forKey: "imageUrl") as! URL,
                                                           searchKey: data.value(forKey: "searchKey") as! String,
                                                           identifier: data.value(forKey: "identifier") as! UUID)
            photoCellVM.editBtnPressed = { [weak self] in
                CoreDataManager.share.deleteData(id: photoCellVM.identifier)
                self?.getFavotite()
            }
            
            if var section = sections[searchKey] {
                section.append(photoCellVM)
                sections[searchKey] = section
            } else {
                sections[searchKey] = [photoCellVM]
            }
        }
        return sections
    }
}
