//
//  UIButton+CGXCollectionCategoryBtnBlock.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

typealias buttonClick = ((_ button:UIButton)->())

extension UIButton {
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
    }
    // 运行时关联
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }
    // 点击回调
    @objc func tapped(button:UIButton){
        if self.actionBlock != nil {
            self.actionBlock!(button)
        }
    }
    // 快速创建s
    func addCGXCollectionCategorySelectBtnBlock(action:@escaping buttonClick) -> Void{
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
    }
    
    ///  gei button 添加一个属性 用于记录点击tag
    private struct AssociatedKeys{
        static var actionKey = "actionKey"
    }
    
    @objc dynamic var actionDic: NSMutableDictionary? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let dic = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? NSDictionary{
                return NSMutableDictionary.init(dictionary: dic)
            }
            return nil
        }
    }
    func addCGXCollectionCategorySelectBtnBlock(action:@escaping  buttonClick ,for controlEvents: UIControl.Event) {
        let eventStr = NSString.init(string: String.init(describing: controlEvents.rawValue))
        if let actions = self.actionDic {
            actions.setObject(action, forKey: eventStr)
            self.actionDic = actions
        }else{
            self.actionDic = NSMutableDictionary.init(object: action, forKey: eventStr)
        }
        
        switch controlEvents {
        case .touchUpInside://按钮内抬起
            self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
        case .touchUpOutside://按钮外抬起
            self.addTarget(self, action: #selector(touchUpOutsideBtnAction), for: .touchUpOutside)
        default:
            break
        }
    }
    
    @objc fileprivate func touchUpInSideBtnAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpInSideAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchUpInside.rawValue)) as? buttonClick{
                touchUpInSideAction(self)
            }
        }
    }
    @objc fileprivate func touchUpOutsideBtnAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpOutsideBtnAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.touchUpOutside.rawValue)) as? buttonClick{
                touchUpOutsideBtnAction(self)
            }
        }
    }
}

