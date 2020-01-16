//
//  FavoriteViewController.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    lazy var controller = {
       return FavoriteController()
    }()
    
    var viewModel:FavoriteViewModel {
        return controller.viewModel
    }
    
    var dataSource: UICollectionViewDiffableDataSource<String, PhotoCollectionCellViewModel>!
    
    let titleElementKind = "title-element-kind"
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: self.titleElementKind,
                                withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout = setCollectionViewLayout()
        configureDataSource()
        initBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.start()
    }
    
}

extension FavoriteViewController {
    func initBinding() {
        viewModel.isLoading.addObserver {[weak self] (isLoading) in
            if isLoading {
                self?.loadingIndicator.startAnimating()
                self?.collectionView.isHidden = true
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.collectionView.isHidden = false
            }
        }
        
        viewModel.sections.addObserver(fireNow:false) {[weak self] (sections) in
            var snapshot = NSDiffableDataSourceSnapshot<String,PhotoCollectionCellViewModel>()
            let keys = sections.keys
            for key in keys {
                snapshot.appendSections([key])
                snapshot.appendItems(sections[key]!, toSection: key)
            }
            self?.dataSource.apply(snapshot,animatingDifferences: false)
        }
    }
}

extension FavoriteViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String,PhotoCollectionCellViewModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: PhotoCollectionCellViewModel) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell", for:indexPath)
            if let cell = cell as? CellConfigurable {cell.setup(viewModel: item)}
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self else { return nil }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.reuseIdentifier, for: indexPath) as? CollectionHeaderView else {return nil}
            let header = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.setTitle(header)
            
            return headerView
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
      let sectionProvider = { (sectionIndex: Int,
               layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
               let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                   0.425 : 0.85)
               let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                      heightDimension: .absolute(250))
               let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
               group.interItemSpacing = .fixed(5)
               
               let section = NSCollectionLayoutSection(group: group)
               section.orthogonalScrollingBehavior = .continuous
               section.interGroupSpacing = 10
               section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
               
               let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
               let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                   layoutSize: titleSize,
                   elementKind: self.titleElementKind,
                   alignment: .top)
               section.boundarySupplementaryItems = [titleSupplementary]
               return section
           }
           let config = UICollectionViewCompositionalLayoutConfiguration()
           config.interSectionSpacing = 20
           
           let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
           return layout
    }
}
