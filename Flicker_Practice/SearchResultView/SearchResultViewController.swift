//
//  SearchResultViewController.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    lazy var controller = {
        return SearchResultController()
    }()
    
    var viewModel:SearchResultViewModel {
        return controller.viewModel
    }
    
    var dataSource: UICollectionViewDiffableDataSource<String, PhotoCollectionCellViewModel>!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        collectionView.collectionViewLayout = setCollectionViewLayout()
        initBinding()
        controller.start()
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.dismiss(animated: true)
    }
    
}

extension SearchResultViewController {
    func initBinding() {
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIndicator.startAnimating()
                self?.collectionView.isHidden = true
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.collectionView.isHidden = false
            }
        }
        
        viewModel.photoCellVMs.addObserver { [weak self] (cellVMs) in
            var snapshot = NSDiffableDataSourceSnapshot<String,PhotoCollectionCellViewModel>()
            snapshot.appendSections(["photos"])
            snapshot.appendItems(cellVMs)
            self?.dataSource.apply(snapshot,animatingDifferences: false)
        }
    }
}

extension SearchResultViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String,PhotoCollectionCellViewModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: PhotoCollectionCellViewModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell", for:indexPath)
            if let cell = cell as? CellConfigurable {cell.setup(viewModel: item)}
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            
            return cell
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
