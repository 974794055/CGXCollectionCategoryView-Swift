//
//  CGXCollectionCategoryGeneralView.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//
/*
#
pod ：CGXCollectionCategoryView-Swift
群名称：

群   号：

版本： 1.4.0

*/

import UIKit

class CGXCollectionCategoryGeneralView: CGXCollectionCategoryBaseView{


    override func initializeData() {
        super.initializeData()
    }
    override func initializeViews() {
        super.initializeViews()
    }
    
    override func preferredFlowLayout() -> UICollectionViewLayout? {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical;
        return layout
    }
    //MARK: - 数据源更新 
    override func updateInfoWith(dataAry: Array<CGXCollectionCategoryBaseSectionModel>, Refresh isRefresh: Bool, Page page: Int, MaxPage maxPage: Int) {
        super.updateInfoWith(dataAry: dataAry, Refresh: isRefresh, Page: page, MaxPage: maxPage)
    }
    //MARK: - 数据源更新 数据初始化
    /*
     替换一个分区的数据源
     */
    func replaceObject(atSection section: Int, withObject sectionModel: CGXCollectionCategoryGeneralSectionModel) {
        if section > dataArray.count - 1 {
            return
        }
        dataArray[section] = sectionModel
        reloadSections(section)
    }
    /*
     替换一个cell数据源
     */
    func replaceObject(atSection section: Int, rowIndex row: Int, withObject rowModel: CGXCollectionCategoryGeneralItemModel) {
        if section > dataArray.count - 1 {
            return
        }
        let sectionModel: CGXCollectionCategoryGeneralSectionModel = dataArray[section] as! CGXCollectionCategoryGeneralSectionModel
        if row > sectionModel.rowArray.count {
            return
        }
        sectionModel.rowArray[row] = rowModel
        let indexPath = IndexPath(row: row, section: section)
        collectionView.reloadItems(at: [indexPath])
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 实现代理   外界不可调用
extension  CGXCollectionCategoryGeneralView {
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[indexPath.section] as! CGXCollectionCategoryGeneralSectionModel
        let rowModel:CGXCollectionCategoryGeneralItemModel = sectionModel.rowArray[indexPath.row] as! CGXCollectionCategoryGeneralItemModel;
        
        assert(sectionModel.row > 0, "每行至少一个item");
        
        var inset = sectionModel.inset
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:insetForSectionAt:))))!{
            inset = (self.delegate?.collectionCategoryView!(self, insetForSectionAt: indexPath.section))!
        }
        let leftSpace:CGFloat = inset.left
        let rightSpace:CGFloat = inset.right
        let KWinW:CGFloat = collectionView.bounds.size.width
        //cell width
        let item_W:CGFloat    =  (KWinW - leftSpace - rightSpace - CGFloat(sectionModel.row-1) * sectionModel.minimumInteritemSpacing) / CGFloat(sectionModel.row)
        //cell height
        let item_H:CGFloat    =   CGFloat(rowModel.itemHeight)
        
        var  size = CGSize.init(width: CGFloat(item_W), height: CGFloat(item_H))
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:width:sizeForItemAt:))))!{
            size = (self.delegate?.collectionCategoryView!(self, width: CGFloat(item_W), sizeForItemAt: indexPath as NSIndexPath))!
        }
        rowModel.itemWidth = size.width
        return CGSize.init(width: floor(size.width), height: floor(size.height))
    }
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:insetForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, insetForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[section] as! CGXCollectionCategoryGeneralSectionModel;
        return sectionModel.inset
    }
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:minimumInteritemSpacingForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, minimumInteritemSpacingForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[section] as! CGXCollectionCategoryGeneralSectionModel;
        return sectionModel.minimumInteritemSpacing
    }
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:minimumLineSpacingForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, minimumLineSpacingForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[section] as! CGXCollectionCategoryGeneralSectionModel;
        return sectionModel.minimumLineSpacing
    }
    //每个分区区头尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[section] as! CGXCollectionCategoryGeneralSectionModel
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:referenceSizeForHeaderInSection:))))!{
            return (self.delegate?.collectionCategoryView!(self, referenceSizeForHeaderInSection: section))!
        }
        if !sectionModel.haderModel.isHaveHeader {
            return  CGSize.init(width: 0, height: 0)
        }
        return  CGSize.init(width: collectionView.frame.size.width, height: sectionModel.haderModel.headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionModel:CGXCollectionCategoryGeneralSectionModel = self.dataArray[section] as! CGXCollectionCategoryGeneralSectionModel
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:referenceSizeForFooterInSection:))))!{
            return (self.delegate?.collectionCategoryView!(self, referenceSizeForFooterInSection: section))!
        }
        if !sectionModel.footerModel.isHaveFooter {
            return  CGSize.init(width: 0, height: 0)
        }
        return  CGSize.init(width: collectionView.frame.size.width, height: sectionModel.footerModel.footerHeight)
    }
}
