//
//  PhotoCollectionViewCell.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/15.
//  Copyright © 2020 tautau. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell,CellConfigurable {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    var viewModel:PhotoCollectionCellViewModel?
    
    func setup(viewModel: CellViewModel) {
        guard let viewModel = viewModel as? PhotoCollectionCellViewModel else { return }
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        RestManager.share.getData(fromURL: viewModel.imageUrl) { (data) in
            guard let data = data, let image = UIImage(data: data) else {return}
            self.photoImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            //sender.isHidden = true
            sender.setImage(UIImage(named: "icon-checkmark"), for: .normal)
            sender.isEnabled = false
        }
        viewModel?.editBtnPressed?()
    }
}
