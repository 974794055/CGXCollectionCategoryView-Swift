//
//  ViewController.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CGXCollectionCategoryBaseViewDelegate {
    
    
    
    var listView = CGXCollectionCategoryGeneralView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .all
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "普通布局"
        listView =  CGXCollectionCategoryGeneralView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.height-(UIApplication.shared.statusBarFrame.size.height > 20 ? 83:49)-(UIApplication.shared.statusBarFrame.size.height > 20 ? 88:64)))
        listView.delegate = self
        self.view.addSubview(listView)
        listView.registerHeader(CGXHeaderReusableView.classForCoder(), isXib: false)
        listView.registerFooter(CGXFooterReusableView.classForCoder(), isXib: false)
        listView.registerCell(CGXCollectionCategoryImageCell.classForCoder(), isXib: false)
        listView.registerCell(CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
        listView.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(updateLoadData))
        listView.collectionView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(updateLoadMoreData))
        updateListData(Refresh: true, Page: 1)
    }
    
    @objc func updateLoadData() -> Void {
        listView.updateLoadData()
    }
    @objc func updateLoadMoreData() -> Void {
        listView.updateLoadMoreData()
    }
    
    func updateListData(Refresh isRefresh: Bool, Page page: Int) -> Void {
        var dataSource = [CGXCollectionCategoryGeneralSectionModel]()
        let num:Int = Int(arc4random() % 21)
        for index in 0..<num {
            let sectionModel = CGXCollectionCategoryGeneralSectionModel()
            
            let haderModel:CGXCollectionCategoryGeneralHeaderModel = CGXCollectionCategoryGeneralHeaderModel.init(headerClass: CGXHeaderReusableView.classForCoder(), isXib:false)
            haderModel.headerBgColor = UIColor.orange
            haderModel.headerTag = index + 10000
            haderModel.isHaveTap = true
            sectionModel.haderModel  = haderModel;
            
            let footerModel:CGXCollectionCategoryGeneralFooterModel = CGXCollectionCategoryGeneralFooterModel.init(footerClass: CGXFooterReusableView.classForCoder(), isXib: false)
            
            footerModel.footerBgColor = UIColor.red
            footerModel.footerTag = index + 10000
            footerModel.isHaveTap = true
            sectionModel.footerModel  = footerModel;
            
            var rowArr = [CGXCollectionCategoryGeneralItemModel]()
            for _ in 0..<4 {
                if index % 2 ==  0 {
                    sectionModel.row = 2
                    let rowModel = CGXCollectionCategoryGeneralItemModel(cellClass: CGXCollectionCategoryTitleCell.classForCoder(), isXib: false)
                    rowModel.dataModel = "美食"
                    rowArr.append(rowModel)
                }else{
                    sectionModel.row = 2
                    let rowModel = CGXCollectionCategoryGeneralItemModel(cellClass: CGXCollectionCategoryImageCell.classForCoder(), isXib: false)
                    rowModel.dataModel = ""
                    rowArr.append(rowModel)
                }
            }
            sectionModel.rowArray = rowArr
            dataSource.append(sectionModel)
        }
        listView.updateInfoWith(dataAry: dataSource, Refresh: isRefresh, Page: page, MaxPage: 20)
        
        
        if dataSource.count < 20 {
            listView.collectionView.mj_footer.isHidden = true
        } else{
            listView.collectionView.mj_footer.isHidden = false
        }
        listView.collectionView.reloadData()
        listView.collectionView.mj_header.endRefreshing()
        listView.collectionView.mj_footer.endRefreshing()
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


extension ViewController {
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
        return CGSize.init(width: width, height: width)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 50)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 50)
    }
    func collectionCategoryView(_ categoryView: CGXCollectionCategoryBaseView, didSelectItemAt indexPath: NSIndexPath) {
        print(indexPath)
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
        self.navigationController!.navigationBar.barTintColor = ViewController.randomColor
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            print("2 秒后输出")
            self.navigationController!.navigationBar.barTintColor = UIColor.white
            self.updateListData(Refresh: isRefresh, Page: page)
        }
        
        
    }
}

