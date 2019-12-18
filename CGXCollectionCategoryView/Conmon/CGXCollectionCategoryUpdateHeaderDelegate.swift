//
//  CGXCollectionCategoryHeaderDelegate.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import Foundation
import UIKit


@objc  protocol CGXCollectionCategoryUpdateHeaderDelegate: NSObjectProtocol {
    
    @objc optional func updateWithCGXCollectionView(HeaderModel headerModel: CGXCollectionCategoryBaseSectionModel, at indexPath: IndexPath)
}
