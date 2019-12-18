//
//  CGXCollectionCategoryBaseItemModel.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryBaseItemModel: NSObject {
    
    open var isSelectedCell: Bool = false
    // 标记tag值
    open var itemtag: Int = 0
    // cell的宽 默认100
    open var itemWidth: CGFloat = 0
    // cell的高 默认100
    open var itemHeight: CGFloat = 100
    // cell的颜色 默认白色
    open var itemColor: UIColor = UIColor.orange
    
    private(set) var itemIsXib = false
    
    //cell的原始数据
    var dataModel: Any?
    /*
     初始化方法
     */
    init(cellClass: AnyClass, isXib: Bool) {
        super.init()
        itemIsXib = isXib
        itemHeight = 100
        isSelectedCell = false
        itemCellClass = cellClass    // Skipping redundant initializing to itself
    }
    /*
     //Class类型 [UICollectionReusableView class]
     */
    var itemCellClass:AnyClass = UICollectionViewCell.classForCoder()
    /*
     //类型 UICollectionReusableView 类
     */
    var itemCellIdentifier:String? {
        get
        {
            var retuntString = "UICollectionViewCell"
            let aa:String = NSStringFromClass(itemCellClass)
            // 1.获取命名空间
            guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
                //print("命名空间不存在")
                return retuntString
            }
            if aa.contains(clsName) {
                if aa.contains(".") {
                    retuntString = aa.replacingOccurrences(of: ".", with: "")
                }
                retuntString = retuntString.replacingOccurrences(of: clsName, with: "", options: String.CompareOptions.caseInsensitive, range: Range.init(NSRange.init(location: 0, length: (clsName as NSString).length), in: clsName))
                
            }
            return retuntString
        }
    }
}
