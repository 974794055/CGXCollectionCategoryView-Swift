//
//  CGXCollectionCategoryBaseView.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit
import Foundation

//MARK:- 自定义打印方法 封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintLogCategoryView<T>(_ message:T, file:String = #file, function:String = #function,
                             line:Int = #line) {
    #if DEBUG
    //获取文件名
    let fileName = (file as NSString).lastPathComponent
    //打印日志内容
    print("\(fileName):\(line) \(function) | \(message)")
    #endif
}

class CGXCollectionCategoryBaseView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //数据源。 外界可读性 不可写入
    lazy var dataArray: [CGXCollectionCategoryBaseSectionModel] = {
        let  array = NSMutableArray()
        return array as! [CGXCollectionCategoryBaseSectionModel]
    }()
    //代理方法
    open weak var delegate: CGXCollectionCategoryBaseViewDelegate?
    
    /// 是否自适应高度
    var isAdaptive:Bool = false
    
    var showsVerticalScrollIndicator:Bool = true
    var showsHorizontalScrollIndicator:Bool = false
    
    //是否下拉刷新
    private var isDownRefresh:Bool = false
    //页码
    private var pageInter:Int = 1
    //是否有空
    private var isHaveNo:Bool = false
    
    
    func preferredFlowLayout() -> UICollectionViewLayout? {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical;
        return layout
    }
    lazy var collectionView: CGXCollectionCategoryCollectionView = {
        let  view = CGXCollectionCategoryCollectionView(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: preferredFlowLayout()!)
        view.backgroundColor = self.backgroundColor;
        view.delegate = self;
        view.dataSource = self;
        view.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        view.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        view.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "\(String(describing: UICollectionViewCell.classForCoder()))")
        view.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(String(describing: UICollectionReusableView.classForCoder()))")
        view.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(String(describing: UICollectionReusableView.classForCoder()))")
        self.addSubview(view);
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initializeViews()
        self.initializeData()
    }
    func initializeData() {
        self.dataArray = NSMutableArray.init() as! [CGXCollectionCategoryBaseSectionModel]
    }
    
    func initializeViews() {
        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isAdaptive {
            let layout = collectionView.collectionViewLayout
            layout.invalidateLayout()
            collectionView.frame = bounds
            if !bounds.size.equalTo(intrinsicContentSize) {
                invalidateIntrinsicContentSize()
            }
            let height: CGFloat? = collectionView.collectionViewLayout.collectionViewContentSize.height
            if height != 0 && height != bounds.size.height {
                var frame: CGRect = self.frame
                frame.size.height = height ?? 0.0
                self.frame = frame
                collectionView.frame = frame
            }
            layoutIfNeeded()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionView.collectionViewLayout.collectionViewContentSize
    }

    
    //MARK: - 数据源更新 数据初始化
    func updateInfoWith(dataAry:Array<CGXCollectionCategoryBaseSectionModel>,Refresh isRefresh:Bool,Page page:Int,MaxPage maxPage:Int) -> Void {
        isHaveNo = true
        isDownRefresh = isRefresh
        pageInter = page
        if isRefresh {
            self.dataArray.removeAll()
        }
        for sectionModel in dataAry {
            self.dataArray.append(sectionModel)
        }
        self.collectionView.reloadData()
    }
    //MARK: - 下拉刷新调用
    func updateLoadData() -> Void {
        self.isDownRefresh = true
        self.pageInter = 1
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:Refresh:Page:))))!{
            self.delegate?.collectionCategoryView?(self, Refresh: self.isDownRefresh, Page: self.pageInter)
        }
    }
    //MARK: - 上拉刷新调用
    func updateLoadMoreData() -> Void {
        self.isDownRefresh = false
        self.pageInter += 1
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:Refresh:Page:))))!{
            self.delegate?.collectionCategoryView?(self, Refresh: self.isDownRefresh, Page: self.pageInter)
        }
    }
    //MARK: - 隐藏键盘
    func hidekeyboard() {
        UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 数据处理刷新
extension  CGXCollectionCategoryBaseView {
    
    func reloadDataAll() -> Void {
        self.collectionView.reloadData()
    }
    //MARK: 刷新单行
    /*
     section:分区
     row:分区的一个item
     */
    func reloadItems(atSection section: Int, rowIndex row: Int) {
        if dataArray.count == 0 {
            return
        }
        let indexPath = IndexPath(row: row , section: section)
        if indexPath.section > dataArray.count - 1 {
            return
        }
        let sectionModel: CGXCollectionCategoryBaseSectionModel? = dataArray[indexPath.section]
        if indexPath.row > sectionModel?.rowArray.count ?? 0 - 1 {
            return
        }
        UIView.animate(withDuration: 0, animations: {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: [indexPath])
            })}, completion: nil);
    }
    //MARK:刷新一个分区
    func reloadSections(_ section: Int) {
        if dataArray.count == 0 {
            return
        }
        if section > dataArray.count - 1 {
            return
        }
        UIView.animate(withDuration: 0, animations: {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(NSIndexSet(index: section) as IndexSet)
            })}, completion: nil);
    }
    
    //MARK:删除一个分区
    func deleteSections(_ section: Int) {
        if dataArray.count == 0 {
            return
        }
        if section > dataArray.count - 1 {
            return
        }
        dataArray.remove(at: section)
        self.collectionView.reloadData()
    }
    //MARK:删除单行
    func deleteItems(atSection section: Int, rowIndex row: Int) {
        self.deleteItems(atSection: section, rowIndex: row, isHead: false)
    }
    /*
     isHead:分区数组为0时是否删除分区头和分区脚数据
     */
    func deleteItems(atSection section: Int, rowIndex row: Int,isHead:Bool) {
        if dataArray.count == 0 {
            return
        }
        if section > dataArray.count - 1 {
            return
        }
        let sectionModel: CGXCollectionCategoryBaseSectionModel = dataArray[section]
        if row > sectionModel.rowArray.count - 1 {
            return
        }
        sectionModel.rowArray.remove(at: row)
        dataArray[section] = sectionModel
        
        if sectionModel.rowArray.count == 0 {
            collectionView.reloadData()
            if isHead == false {
                self.deleteSections(section)
            }
        } else{
            let indexPathNew = IndexPath(row: row, section: section)
            self.collectionView.deleteItems(at: [indexPathNew])
        }
    }
    //MARK:插入一个分区
    func insertSections(_ section: Int,sectionModel:CGXCollectionCategoryBaseSectionModel) {
        if dataArray.count == 0 {
            if section > 0 {
                return
            }
        } else{
            if section > dataArray.count - 1 {
                return
            }
        }
        self.dataArray.insert(sectionModel, at: section)
        if self.dataArray.count == 1{
            collectionView.reloadData()
        } else{
            collectionView.insertSections(NSIndexSet(index: section) as IndexSet)
        }
    }
    //MARK:插入单行  超出边界 添加再最后，无数据时添加在第一个位置
    func insertItems(atSection section: Int, rowIndex row: Int,itemModel:CGXCollectionCategoryBaseItemModel) {
        if dataArray.count == 0 {
            if section > dataArray.count - 1 {
                return
            }
        } else{
            if section > dataArray.count - 1 {
                return
            }
        }
        let sectionModel: CGXCollectionCategoryBaseSectionModel = dataArray[section]
        if row > sectionModel.rowArray.count - 1 {
            return
        }
        sectionModel.rowArray.insert(itemModel, at: row)
        dataArray[section] = sectionModel
        if sectionModel.rowArray.count == 1 {
            self.collectionView.reloadData()
        } else{
            collectionView.insertItems(at: [NSIndexPath.init(row: row, section: section) as IndexPath])
        }
    }
}
//MARK: - 注册cell 头分区、脚分区
extension  CGXCollectionCategoryBaseView {
    open  func registerCell(_ classCell: AnyClass, isXib: Bool) {
        if !(classCell.self is UICollectionViewCell.Type) {
            assert(!(classCell.self is UICollectionViewCell.Type), "注册cell的必须是UICollectionViewCell类型")
        }
        if isXib {
            collectionView.register(UINib(nibName: "\(String(describing: classCell))", bundle: nil), forCellWithReuseIdentifier: "\(String(describing: classCell))")
        } else {
            collectionView.register(classCell, forCellWithReuseIdentifier: "\(String(describing: classCell))")
        }
    }
    open  func registerFooter(_ footer: AnyClass, isXib: Bool) {
        if !(footer.self is UICollectionReusableView.Type) {
            assert(!(footer.self is UICollectionReusableView.Type), "注册footer必须是UICollectionReusableView类型")
        }
        if isXib {
            collectionView.register(UINib(nibName: "\(String(describing: footer))", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(String(describing: footer))")
        } else {
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(String(describing: footer))")
        }
    }
    open func registerHeader(_ header: AnyClass, isXib: Bool) {
        if !(header.self is UICollectionReusableView.Type){
            assert(!(header.self is UICollectionReusableView.Type), "注册header必须是UICollectionReusableView类型")
        }
        if isXib {
            collectionView.register(UINib(nibName: "\(String(describing: header))", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(String(describing: header))")
        } else {
            collectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(String(describing: header))")
        }
    }
}
//MARK: - UICollectionView 代理
extension  CGXCollectionCategoryBaseView {
    //分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count;
    }
    //每个分区含有的 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel:CGXCollectionCategoryBaseSectionModel = self.dataArray[section];
        return sectionModel.rowArray.count
    }
    //返回区头、区尾实例
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel:CGXCollectionCategoryBaseSectionModel = self.dataArray[indexPath.section];
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionModel.haderModel.headerIdentifier!, for: indexPath as IndexPath)
            headerView.backgroundColor = sectionModel.haderModel.headerBgColor
            headerView.tag = sectionModel.haderModel.headerTag
            
//            for view in headerView.subviews {
//                view.removeFromSuperview()
//            }
//            let headV = create(forClass: sectionModel.haderModel.headerIdentifier!)
//            headV.backgroundColor = sectionModel.footerModel.footerBgColor
//            headV.tag = sectionModel.footerModel.footerTag
//            headV.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height)
//            headerView.addSubview(headV)
            //实现cell的代理
            let isHave: Bool = headerView.responds(to: #selector(CGXCollectionCategoryUpdateHeaderDelegate.updateWithCGXCollectionView(HeaderModel:at:)))
            if isHave == true && headerView is CGXCollectionCategoryUpdateHeaderDelegate {
                (headerView as? (UICollectionReusableView & CGXCollectionCategoryUpdateHeaderDelegate))?.updateWithCGXCollectionView?(HeaderModel: sectionModel, at: indexPath)
            }
            //外界处理headerView的代理
            if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:headerView:KindHeader:))))!{
                self.delegate?.collectionCategoryView?(self, headerView: headerView, KindHeader: indexPath)
            }
            if sectionModel.haderModel.isHaveTap {
                headerView.addGXTaptouchBlock { [weak self]  tap in
                    if self?.delegate != nil && (self?.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:headerView:TapKindHeader:))))!{
                        self?.delegate?.collectionCategoryView?(self!, headerView: headerView, TapKindHeader: indexPath)
                    }
                }
            }
            return headerView;
        } else {
            let  footerView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionModel.footerModel.footerIdentifier!, for: indexPath as IndexPath)
            for view in footerView.subviews {
                view.removeFromSuperview()
            }
            let footV = create(forClass: sectionModel.footerModel.footerIdentifier!)
            footV.backgroundColor = sectionModel.footerModel.footerBgColor
            footV.tag = sectionModel.footerModel.footerTag
            footV.frame = CGRect.init(x: 0, y: 0, width: footerView.frame.size.width, height: footerView.frame.size.height)
            footerView.addSubview(footV)
            //实现cell的代理
            let isHave: Bool = footV.responds(to: #selector(CGXCollectionCategoryUpdateFooterDelegate.updateWithCGXCollectionView(FooterModel:at:)))
            if isHave == true && footV is CGXCollectionCategoryUpdateFooterDelegate {
                (footV as? (UICollectionReusableView & CGXCollectionCategoryUpdateFooterDelegate))?.updateWithCGXCollectionView?(FooterModel: sectionModel, at: indexPath)
            }
            //外界处理footerView的代理
            if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:footerView:KindFooter:))))!{
                self.delegate?.collectionCategoryView?(self, footerView: footV, KindFooter: indexPath)
            }
            
            if sectionModel.footerModel.isHaveTap {
                footV.addGXTaptouchBlock { [weak self]  tap in
                    if self?.delegate != nil && (self?.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:footerView:TapKindFooter:))))!{
                        self?.delegate?.collectionCategoryView?(self!, footerView: footV, TapKindFooter: indexPath)
                    }
                }
            }
            
            return footerView;
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.delegate != nil && (self.delegate?.responds(to: #selector( CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:cellForItemAt:))))!{
            return (self.delegate?.collectionCategoryView?(self, cellForItemAt: indexPath))!
        }
        let sectionModel:CGXCollectionCategoryBaseSectionModel = self.dataArray[indexPath.section];
        let rowModel:CGXCollectionCategoryBaseItemModel = sectionModel.rowArray[indexPath.row];
        
        let cell:UICollectionViewCell!=collectionView.dequeueReusableCell(withReuseIdentifier: "\(String(describing: rowModel.itemCellClass))", for: indexPath)
        
        cell.contentView.backgroundColor = rowModel.itemColor
        
        //实现cell的代理
        let isHave: Bool = cell.responds(to: #selector(CGXCollectionViewUpdateCellDelegate.updateWithCGXCollectionView(CellModel:at:)))
        if isHave == true && cell is CGXCollectionViewUpdateCellDelegate {
            (cell as? (UICollectionViewCell & CGXCollectionViewUpdateCellDelegate))?.updateWithCGXCollectionView?(CellModel: rowModel, at: indexPath)
        }
        //外界处理展示cell
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:baseCell:cellShowItemAt:))))!{
            self.delegate?.collectionCategoryView?(self, baseCell: cell, cellShowItemAt: indexPath)
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:didSelectItemAt:))))!{
            return (self.delegate?.collectionCategoryView?(self, didSelectItemAt: indexPath as NSIndexPath))!
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:scrollViewDidScroll:))))!{
            return (self.delegate?.collectionCategoryView?(self, scrollViewDidScroll: scrollView))!
        }
    }
    
    
   private func create(forClass name: String) -> UICollectionReusableView {
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            PrintLogCategoryView("命名空间不存在")
            return UICollectionReusableView.init()
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString(clsName + "." + name)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UICollectionReusableView.Type else {
            PrintLogCategoryView("无法转换成UICollectionReusableView")
            return UICollectionReusableView.init()
        }
        // 3.通过Class创建对象
        let reusableView = clsType.init()
        return reusableView
    }
}

//MARK: - 外界使用的代理
@objc protocol CGXCollectionCategoryBaseViewDelegate: NSObjectProtocol {
    /**刷新代理 */
    @objc  optional   func collectionCategoryView(_ categoryView:CGXCollectionCategoryBaseView,Refresh isRefresh:Bool, Page page:Int) -> Void
    /**代理函数 cell的显示 */
    @objc  optional   func collectionCategoryView(_ categoryView:CGXCollectionCategoryBaseView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    //展示cell 外界处理cell的功能
    @objc  optional   func collectionCategoryView(_ categoryView:CGXCollectionCategoryBaseView,baseCell:UICollectionViewCell, cellShowItemAt indexPath: IndexPath) -> Void
    //点击事件
    @objc  optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, didSelectItemAt indexPath: NSIndexPath) -> Void
    //每个分区的内边距
    @objc  optional  func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, insetForSectionAt section: Int) -> UIEdgeInsets
    // item 间距
    @objc optional  func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    //行间距
    @objc optional  func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    //item 的尺寸
    @objc  optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, width:CGFloat, sizeForItemAt indexPath: NSIndexPath) -> CGSize
    //头分区高度
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForHeaderInSection section: Int) -> CGSize
    //脚分区高度
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForFooterInSection section: Int) -> CGSize
    //头分区view
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView,headerView :UICollectionReusableView,KindHeader  indexPath: IndexPath) -> Void
    //脚分区view
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView,footerView :UICollectionReusableView,KindFooter  indexPath: IndexPath) -> Void
    //脚分区view  轻拍
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView,headerView :UICollectionReusableView, TapKindHeader  indexPath: IndexPath) -> Void
    //脚分区view  轻拍
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView,footerView :UICollectionReusableView, TapKindFooter  indexPath: IndexPath) -> Void
    /*滚动*/
    @objc optional func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView,scrollViewDidScroll :UIScrollView) -> Void
}
