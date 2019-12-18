//
//  WaterViewController.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

//屏幕宽
let ScreenWidth = UIScreen.main.bounds.size.width
//屏幕高
let ScreenHeight = UIScreen.main.bounds.size.height

class WaterViewController: UIViewController,CGXCollectionCategoryBaseViewDelegate {
    
    var listView = CGXCollectionCategoryWaterView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = []
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "流水布局"
        listView =  CGXCollectionCategoryWaterView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.height-(UIApplication.shared.statusBarFrame.size.height > 20 ? 83:49)-(UIApplication.shared.statusBarFrame.size.height > 20 ? 88:64)))
        listView.delegate = self
        self.view.addSubview(listView)
        listView.registerHeader(CGXHeaderReusableView.classForCoder(), isXib: false)
        listView.registerFooter(CGXFooterReusableView.classForCoder(), isXib: false)
        listView.registerCell(CGXCollectionCategoryImageCell.classForCoder(), isXib: false)
        listView.registerCell(CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
        
        var dataSource = [CGXCollectionCategoryWaterSectionModel]()
        dataSource = CGXWaterTools.loadDealWithList()
        listView.updateInfoWith(dataAry: dataSource, Refresh: true, Page: 1, MaxPage: 20)
        
        let item1 = UIBarButtonItem.init(title: "替换1", style: .done, target: self, action: #selector(aaaa))
        let item2 = UIBarButtonItem.init(title: "替换2", style: .done, target: self, action: #selector(bbbbb))
        let item3 = UIBarButtonItem.init(title: "删除1", style: .done, target: self, action: #selector(cccc))
        let item4 = UIBarButtonItem.init(title: "删除2", style: .done, target: self, action: #selector(dddd))
        let item5 = UIBarButtonItem.init(title: "添加1", style: .done, target: self, action: #selector(eeee))
        let item6 = UIBarButtonItem.init(title: "添加2", style: .done, target: self, action: #selector(ffff))
        
        
        self.navigationItem.leftBarButtonItems = [item1,item2,item3]
        self.navigationItem.rightBarButtonItems = [item4,item5,item6]
        
        
        
    }
    //替换一个分区
    @objc func aaaa() -> Void {
        CGXWaterTools.replaceObjectAtSection(section: 0, listView: listView)
    }
    //替换一个cell
    @objc func bbbbb() -> Void {
        CGXWaterTools.replaceObjectAtSectionForRow(section: 0, row: 0, listView: listView)
    }
    //删除1
    @objc func cccc() -> Void {
        listView.deleteSections(0)
    }
    //删除2
    @objc func dddd() -> Void {
        listView.deleteItems(atSection: 0, rowIndex: 0)
    }
    
    @objc func eeee() -> Void {
        
        
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
        listView.insertSections(0, sectionModel: secModel)

    }
    @objc func ffff() -> Void {
        let rowModel = CGXCollectionCategoryWaterItemModel(cellClass: CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
        rowModel.itemHeight = 100
        
        rowModel.itemColor = WaterViewController.randomColor
        
        listView.insertItems(atSection: 0, rowIndex: 0, itemModel: rowModel)
    }
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}


extension WaterViewController {
    
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, width: CGFloat, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
        let sectionModel:CGXCollectionCategoryWaterSectionModel = categoryView.dataArray[indexPath.section] as! CGXCollectionCategoryWaterSectionModel;
        let rownModel:CGXCollectionCategoryWaterItemModel = sectionModel.rowArray[indexPath.row] as! CGXCollectionCategoryWaterItemModel;
        return CGSize.init(width: width, height: rownModel.itemHeight)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 50)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 50)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, didSelectItemAt indexPath: NSIndexPath) {
        print("didSelectItemAt:\(indexPath)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, footerView: UICollectionReusableView, KindFooter indexPath: IndexPath) {
        print("footerView:\(footerView)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, headerView: UICollectionReusableView, KindHeader indexPath: IndexPath) {
        print("headerView:\(headerView)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, baseCell: UICollectionViewCell, cellShowItemAt indexPath: IndexPath) {
        print("baseCell:\(baseCell)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, headerView: UICollectionReusableView, TapKindHeader indexPath: IndexPath) {
        print("TapKindHeader:\(headerView)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, footerView: UICollectionReusableView, TapKindFooter indexPath: IndexPath) {
        print("TapKindFooter:\(footerView)")
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, Refresh isRefresh: Bool, Page page: Int) {
        print("Refresh:\(isRefresh)--Page:\(page)")
    }
    
}

