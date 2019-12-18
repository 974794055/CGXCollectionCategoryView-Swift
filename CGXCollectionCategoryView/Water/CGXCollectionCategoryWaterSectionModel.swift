//
//  CGXCollectionCategoryWaterSectionModel.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryWaterSectionModel: CGXCollectionCategoryBaseSectionModel {

    //  两列情况下使用
    // 此方法排列方式  偶数下标在左边。奇数下标在右边。
    var isParityAItem: Bool = false
    //某个分区是否是奇偶瀑布流排布
    var isParityFlow: Bool = false

    
    override init() {
        super.init()
    }
}
