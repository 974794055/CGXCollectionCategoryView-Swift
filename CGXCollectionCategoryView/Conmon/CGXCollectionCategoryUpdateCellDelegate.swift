//
//  CGXCollectionCategoryCellDelegate.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import Foundation
import UIKit


@objc  protocol CGXCollectionViewUpdateCellDelegate: NSObjectProtocol {
  @objc optional func updateWithCGXCollectionView(CellModel cellModel: CGXCollectionCategoryBaseItemModel, at indexPath: IndexPath)
}
