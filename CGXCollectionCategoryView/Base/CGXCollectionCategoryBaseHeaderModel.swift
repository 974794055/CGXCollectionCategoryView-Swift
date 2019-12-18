//
//  CGXCollectionCategoryBaseHeaderModel.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryBaseHeaderModel: NSObject {
    
    /*
     初始化方法
     */
    init(headerClass: AnyClass, isXib: Bool) {
        super.init()
        if !(headerClass.self is UICollectionReusableView.Type){
            assert(!(headerClass.self is UICollectionReusableView.Type), "注册header必须是UICollectionReusableView类型")
        }
        self.headerClass = headerClass
        headerXib = isXib
        headerHeight = 0.01
        headerTag = 0
        headerBgColor = UIColor(red: 241 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
        isHaveHeader = true
    }
    /*
     //Class类型 [UICollectionReusableView class]
     */
    var headerClass:AnyClass = UICollectionReusableView.classForCoder()
    /*
     //类型 UICollectionReusableView 类
     */
    var headerIdentifier:String? {
        get
        {
            var retuntString = "UICollectionReusableView"
            let aa:String = NSStringFromClass(headerClass)
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
    
    /*
     是否是xib创建
     */
    private(set) var headerXib:Bool = false
    /*
     高度
     */
    var headerHeight: CGFloat = 0.0
    /*
     颜色
     */
    var headerBgColor: UIColor?
    /*
     原始数据
     */
    var headerModel: Any?
    /*
     设置标签值 默认0
     */
    var headerTag: Int = 0
    /*
     是否有头分区
     */
    var isHaveHeader = true
    
    /*
     是否有头分区d轻拍
     */
    var isHaveTap = false
}
