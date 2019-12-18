//
//  CGXCollectionCategoryBaseTitleCell.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryTitleCell: UICollectionViewCell,CGXCollectionViewUpdateCellDelegate {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(label)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithCGXCollectionView(CellModel cellModel: CGXCollectionCategoryBaseItemModel, at indexPath: IndexPath) {
//        print("\nupdateWithCGXCollectionView:\n\(cellModel.itemCellIdentifier!)")
        titleLabel.backgroundColor = cellModel.itemColor
        var  ss = ""
        if cellModel.dataModel is String {
            ss = cellModel.dataModel as! String
        }
        titleLabel.text = ss + "section:" + "\(indexPath.section)" + "\nrow:" + "\(indexPath.row)"
    }
}
