//
//  CGXCollectionCategoryBaseImageCell.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryImageCell: UICollectionViewCell,CGXCollectionViewUpdateCellDelegate {
    lazy var itemImageView:UIImageView = {
        let imageView = UIImageView.init()
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemImageView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        itemImageView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateWithCGXCollectionView(CellModel cellModel: CGXCollectionCategoryBaseItemModel, at indexPath: IndexPath) {
//        print("\nupdateWithCGXCollectionView:\n\(cellModel.itemCellIdentifier!)")
        itemImageView.backgroundColor = cellModel.itemColor
        var  named = "PlaceholderImage"
        if cellModel.dataModel is String {
            named = cellModel.dataModel as! String
        }
        itemImageView.image = UIImage.init(named: named)
    }

}
