//
//  CGXCollectionCategoryBaseFooterModel.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryBaseFooterModel: NSObject {
    /*
     初始化方法
     */
    init(footerClass: AnyClass, isXib: Bool) {
        super.init()
        if !(footerClass.self is UICollectionReusableView.Type){
            assert(!(footerClass.self is UICollectionReusableView.Type), "注册footer必须是UICollectionReusableView类型")
        }
        self.footerClass = footerClass
        footerXib = isXib
        footerHeight = 0.01
        footerTag = 0
        footerBgColor = UIColor(red: 241 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
        isHaveFooter = true
    }
    /*
     //Class类型 [UICollectionReusableView class]
     */
    var footerClass:AnyClass = UICollectionReusableView.classForCoder()
    /*
     //类型 UICollectionReusableView 类
     */
    var footerIdentifier:String? {
        get
        {
            var retuntString = "UICollectionReusableView"
            let aa:String = NSStringFromClass(footerClass)
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
    private(set) var footerXib:Bool = false
    /*
     高度
     */
    var footerHeight: CGFloat = 0.0
    /*
     颜色
     */
    var footerBgColor: UIColor?
    /*
     原始数据
     */
    var footerModel: Any?
    /*
     设置标签值 默认0
     */
    var footerTag: Int = 0
    /*
     是否有脚分区
     */
    var isHaveFooter = true
    
    /*
     是否有脚分区轻拍
     */
    var isHaveTap = false
}
