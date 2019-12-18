//
//  WaterTools.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXWaterTools: NSObject {

    class func loadDealWithList() -> [CGXCollectionCategoryWaterSectionModel] {
        var dataSource = [CGXCollectionCategoryWaterSectionModel]()
        for index in 0..<4 {
            let sectionModel = CGXCollectionCategoryWaterSectionModel()
            
            let haderModel:CGXCollectionCategoryWaterHeaderModel = CGXCollectionCategoryWaterHeaderModel.init(headerClass: CGXHeaderReusableView.classForCoder(), isXib: false)
            haderModel.headerBgColor = UIColor.orange
            haderModel.headerTag = index + 10000
            sectionModel.haderModel  = haderModel;
            haderModel.isHaveTap = true
            let footerModel:CGXCollectionCategoryWaterFooterModel = CGXCollectionCategoryWaterFooterModel.init(footerClass: CGXFooterReusableView.classForCoder(), isXib: false)
            footerModel.footerBgColor = UIColor.red
            footerModel.footerTag = index + 20000
            footerModel.isHaveTap = true
            sectionModel.footerModel  = footerModel;
            
            var rowArr = [CGXCollectionCategoryWaterItemModel]()
            for _ in 0..<6 {
                sectionModel.isParityFlow = true
                sectionModel.isParityAItem = true
                let rowModel = CGXCollectionCategoryWaterItemModel(cellClass: CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
                if index == 0 {
                    rowModel.itemHeight = 100
                } else {
                    rowModel.itemHeight = 80+CGFloat(arc4random() % 50)
                }
                rowModel.dataModel = "美食"
                rowArr.append(rowModel)
            }
            sectionModel.rowArray = rowArr
            dataSource.append(sectionModel)
        }
        return dataSource
    }
    //替换一个分区
    class func replaceObjectAtSection(section:Int,listView:CGXCollectionCategoryWaterView) -> Void {
        if listView.dataArray.count == 0{
            return
        }
        if  section > listView.dataArray.count-1{
            return
        }
        let sectionModel = CGXCollectionCategoryWaterSectionModel()
        let haderModel:CGXCollectionCategoryWaterHeaderModel = CGXCollectionCategoryWaterHeaderModel.init(headerClass: CGXHeaderReusableView.classForCoder(), isXib: false)
        haderModel.headerBgColor = UIColor.orange
        haderModel.headerTag = 0 + 10000
        sectionModel.haderModel  = haderModel;
        haderModel.isHaveTap = true
        let footerModel:CGXCollectionCategoryWaterFooterModel = CGXCollectionCategoryWaterFooterModel.init(footerClass: CGXFooterReusableView.classForCoder(), isXib: false)
        footerModel.footerBgColor = UIColor.red
        footerModel.footerTag = 0 + 20000
        footerModel.isHaveTap = true
        sectionModel.footerModel  = footerModel;
        
        var rowArr = [CGXCollectionCategoryWaterItemModel]()
        for _ in 0..<6 {
            sectionModel.isParityFlow = true
            sectionModel.isParityAItem = true
            let rowModel = CGXCollectionCategoryWaterItemModel(cellClass: CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
            rowModel.itemHeight = 40+CGFloat(arc4random() % 200)
            rowModel.itemColor = WaterViewController.randomColor
            rowModel.dataModel = "美食"
            rowArr.append(rowModel)
        }
        sectionModel.rowArray = rowArr
        listView.replaceObject(atSection: section, withObject: sectionModel)
    }
    //替换一个cell
    class func replaceObjectAtSectionForRow(section:Int,row:Int,listView:CGXCollectionCategoryWaterView) -> Void {
        if listView.dataArray.count == 0{
            return
        }
        if  section > listView.dataArray.count-1{
            return
        }
        let secModel:CGXCollectionCategoryWaterSectionModel = listView.dataArray[section] as! CGXCollectionCategoryWaterSectionModel
        
        if secModel.rowArray.count == 0{
            return
        }
        if  row > secModel.rowArray.count-1{
            return
        }
        let itemModel:CGXCollectionCategoryWaterItemModel = secModel.rowArray[row] as! CGXCollectionCategoryWaterItemModel
        itemModel.itemColor = WaterViewController.randomColor
        listView.replaceObject(atSection: section, rowIndex: row, withObject: itemModel)
    }
    //
    class func addObjectAtSectionForRow(section:Int,row:Int,listView:CGXCollectionCategoryWaterView) -> Void {
        
        let secModel = CGXCollectionCategoryWaterSectionModel()
        let haderModel:CGXCollectionCategoryWaterHeaderModel = CGXCollectionCategoryWaterHeaderModel.init(headerClass: CGXHeaderReusableView.classForCoder(), isXib: false)
        haderModel.headerBgColor = UIColor.orange
        haderModel.headerTag =  10000
        haderModel.isHaveTap = true
        secModel.haderModel  = haderModel;
        
        let footerModel:CGXCollectionCategoryWaterFooterModel = CGXCollectionCategoryWaterFooterModel.init(footerClass: CGXFooterReusableView.classForCoder(), isXib: false)
        footerModel.footerBgColor = UIColor.red
        footerModel.footerTag =  10000
        footerModel.isHaveTap = true
        secModel.footerModel  = footerModel;
        
        var rowArr = [CGXCollectionCategoryWaterItemModel]()
        for _ in 0..<2 {
            secModel.isParityFlow = true
            secModel.isParityAItem = true
            let rowModel = CGXCollectionCategoryWaterItemModel(cellClass: CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
            rowModel.itemHeight = 100
            rowArr.append(rowModel)
        }
        secModel.rowArray = rowArr
        listView.insertSections(section, sectionModel: secModel)
    }
}
