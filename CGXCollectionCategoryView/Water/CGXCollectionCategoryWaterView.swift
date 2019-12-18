//
//  CGXCollectionCategoryWaterView.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryWaterView: CGXCollectionCategoryBaseView,CGXCollectionCategoryWaterLayoutDelegate {
    //MARK: - 初始化
    override func initializeData() {
        super.initializeData()
        self.collectionView.reloadData()
    }
    override func initializeViews() {
        super.initializeViews()
    }
    override func preferredFlowLayout() -> UICollectionViewLayout? {
        let layout = CGXCollectionCategoryWaterLayout()
        layout.dataSource = self
        return layout
    }
    //MARK: - 更新数据源
    override func updateInfoWith(dataAry: Array<CGXCollectionCategoryBaseSectionModel>, Refresh isRefresh: Bool, Page page: Int, MaxPage maxPage: Int) {
        super.updateInfoWith(dataAry: dataAry, Refresh: isRefresh, Page: page, MaxPage: maxPage)
    }
}
//MARK: - 数据源更新 数据初始化
extension  CGXCollectionCategoryWaterView {
    /*
     替换一个分区的数据源
     */
    func replaceObject(atSection section: Int, withObject sectionModel: CGXCollectionCategoryWaterSectionModel) {
        if section > dataArray.count - 1 {
            return
        }
        dataArray[section] = sectionModel
        reloadSections(section)
    }
    /*
     替换一个cell数据源
     */
    func replaceObject(atSection section: Int, rowIndex row: Int, withObject rowModel: CGXCollectionCategoryWaterItemModel) {
        if section > dataArray.count - 1 {
            return
        }
        let sectionModel: CGXCollectionCategoryWaterSectionModel = dataArray[section] as! CGXCollectionCategoryWaterSectionModel
        if row > sectionModel.rowArray.count {
            return
        }
        sectionModel.rowArray[row] = rowModel
        let indexPath = IndexPath(row: row, section: section)
        collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - 实现代理   外界不可调用
extension  CGXCollectionCategoryWaterView {
    /// Return per section's column number(must be greater than 0).
    func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, numberOfColumnInSection section: Int) -> Int
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel;
        return sectionModel.row
    }
    /// Return per item's height   高度设置无效 等宽的
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, itemWidth width: CGFloat, heightForItemAt indexPath: IndexPath) -> CGSize
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[indexPath.section] as! CGXCollectionCategoryWaterSectionModel;
        let rownModel:CGXCollectionCategoryWaterItemModel = sectionModel.rowArray[indexPath.row] as! CGXCollectionCategoryWaterItemModel;
        
        assert((sectionModel.row > 0), "每行至少一个整数")
        var inset = sectionModel.inset
        
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:insetForSectionAt:))))!{
            inset = (self.delegate?.collectionCategoryView!(self, insetForSectionAt: indexPath.section))!
        }
        let leftSpace:CGFloat = inset.left
        let rightSpace:CGFloat = inset.right
        
        let KWinW:CGFloat = CGFloat(collectionView.bounds.size.width)
        
        var minimumInteritemSpacing:CGFloat = sectionModel.minimumInteritemSpacing
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:minimumInteritemSpacingForSectionAt:))))!{
            minimumInteritemSpacing = (self.delegate?.collectionCategoryView!(self, minimumInteritemSpacingForSectionAt: indexPath.section))!
        }
        
        //cell width
        let item_W:CGFloat    =   (KWinW - leftSpace - rightSpace - CGFloat(sectionModel.row-1)*minimumInteritemSpacing) / CGFloat(sectionModel.row)
        //cell height
        let item_H:CGFloat    =   rownModel.itemHeight
        var  size = CGSize.init(width: CGFloat(item_W), height: CGFloat(item_H))
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:width:sizeForItemAt:))))!{
            size = (self.delegate?.collectionCategoryView!(self, width: CGFloat(item_W), sizeForItemAt: indexPath as NSIndexPath))!
        }
        return size
        
    }
    /// Column spacing between columns
    //   此方法排列方式  偶数下标在左边。奇数下标在右边。   两列情况下使用
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, isParityAItemAt indexPath: IndexPath) -> Bool
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[indexPath.section] as! CGXCollectionCategoryWaterSectionModel;
        if (sectionModel.isParityAItem) {
            if (indexPath.row % 2 == 0) {
                return false;
            } else{
                return true;
            }
        }
        return false
    }
    /*
     某个分区是否是奇偶瀑布流排布
     */
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, isParityFlowAtInSection section: Int) -> Bool
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel;
        return sectionModel.isParityFlow
    }
    //行间距
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:minimumLineSpacingForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, minimumLineSpacingForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel;
        return sectionModel.minimumLineSpacing
    }
    // item 间距
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:minimumInteritemSpacingForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, minimumInteritemSpacingForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel;
        return sectionModel.minimumInteritemSpacing
    }
    //每个分区的内边距
    internal func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:insetForSectionAt:))))!{
            return (self.delegate?.collectionCategoryView!(self, insetForSectionAt: section))!
        }
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel;
        return sectionModel.inset
    }
    //头分区高度
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, referenceHeightForHeaderInSection section: Int) -> CGSize
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:referenceSizeForHeaderInSection:))))!{
            return (self.delegate?.collectionCategoryView!(self, referenceSizeForHeaderInSection: section))!
        }
        if !sectionModel.haderModel.isHaveHeader {
            return  CGSize.init(width: 0, height: 0)
        }
        return  CGSize.init(width: collectionView.frame.size.width, height: sectionModel.haderModel.headerHeight)
    }
    //脚分区高度
     func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, referenceHeightForFooterInSection section: Int) -> CGSize
    {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = self.dataArray[section] as! CGXCollectionCategoryWaterSectionModel
        if self.delegate != nil && (self.delegate?.responds(to: #selector(CGXCollectionCategoryBaseViewDelegate.collectionCategoryView(_:referenceSizeForFooterInSection:))))!{
            return (self.delegate?.collectionCategoryView!(self, referenceSizeForFooterInSection: section))!
        }
        if !sectionModel.footerModel.isHaveFooter {
            return  CGSize.init(width: 0, height: 0)
        }
        return  CGSize.init(width: collectionView.frame.size.width, height: sectionModel.footerModel.footerHeight)
    }
}
