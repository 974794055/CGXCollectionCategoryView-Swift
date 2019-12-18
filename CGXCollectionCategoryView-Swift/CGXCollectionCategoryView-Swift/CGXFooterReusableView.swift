//
//  CGXFooterReusableView.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/5/27.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXFooterReusableView: UICollectionReusableView,CGXCollectionCategoryUpdateFooterDelegate {
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(label)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.frame = CGRect.init(x: 30, y: 0, width: frame.size.width-60, height: frame.size.height)
        titleLabel.backgroundColor = UIColor.green
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect.init(x: 30, y: 0, width: frame.size.width-60, height: frame.size.height)
    }
    func updateWithCGXCollectionView(FooterModel footerModel: CGXCollectionCategoryBaseSectionModel, at indexPath: IndexPath) {
//        print("footerModel--tag：\(footerModel.haderModel.headerTag)")
        titleLabel.text = "脚分区" + "\(indexPath.section)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
