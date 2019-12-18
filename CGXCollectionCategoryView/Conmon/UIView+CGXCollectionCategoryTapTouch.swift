//
//  UIButton+CGXCollectionCategoryTapTouch.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

typealias tapGXTouchClick = ((_ tap:UITapGestureRecognizer)->())

extension UIView: UIGestureRecognizerDelegate {

    // 改进写法【推荐】
    private struct RuntimeKey {
        static let tapGXActionBlock = UnsafeRawPointer.init(bitPattern: "tapTouchClick".hashValue)
    }
    // 运行时关联
    private var tapGXActionBlock: tapGXTouchClick? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.tapGXActionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIView.RuntimeKey.tapGXActionBlock!) as? tapGXTouchClick
        }
    }
    // 点击回调
    @objc func tapGXAction(tap:UITapGestureRecognizer){
        if self.tapGXActionBlock != nil {
            self.tapGXActionBlock!(tap)
        }
    }
    // 快速创建
    func addGXTaptouchBlock(action:@escaping tapGXTouchClick) -> Void{
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapGXAction(tap:)))
        self.addGestureRecognizer(tap)
        self.tapGXActionBlock = action
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
 
        let touchClass = NSStringFromClass((touch.view?.classForCoder)!)
        let supClass = NSStringFromClass((touch.view?.superview!.superview?.classForCoder)!)
        if touchClass == "UITableView" || touchClass == "UICollectionView" ||
            supClass == "UITableView" || supClass == "UICollectionView" {
            return false
        }
        if (NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView") {
            return false
        }
        
        if touchClass == "\(String(describing: self.classForCoder))" || supClass == "\(String(describing: self.classForCoder))" {
            return false
        }
        return true
    }
}
