//
//  CGXCollectionCategoryBaseSectionModel.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryBaseSectionModel: NSObject {

    var rowArray = [CGXCollectionCategoryBaseItemModel]()
    // 每行默认两个列数
    var row:Int = 2
    var itemSpacing: CGFloat = 10

    var minimumInteritemSpacing: CGFloat = 10
    var minimumLineSpacing: CGFloat = 10
    var inset:UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    
    var haderModel:CGXCollectionCategoryBaseHeaderModel = CGXCollectionCategoryBaseHeaderModel.init(headerClass: UICollectionReusableView.classForCoder(), isXib:false)
    
    var footerModel:CGXCollectionCategoryBaseFooterModel = CGXCollectionCategoryBaseFooterModel.init(footerClass: UICollectionReusableView.classForCoder(), isXib:false)

    override init() {
        super.init()
        rowArray = NSMutableArray.init() as! [CGXCollectionCategoryBaseItemModel]
    }
}
