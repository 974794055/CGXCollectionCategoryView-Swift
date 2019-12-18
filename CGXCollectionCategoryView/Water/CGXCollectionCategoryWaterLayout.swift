//
//  CGXCollectionCategoryWaterLayout.swift
//  CGXCollectionCategoryView-Swift
//
//  Created by CGX on 2019/05/01.
//  Copyright © 2019 CGX. All rights reserved.
//

import UIKit

class CGXCollectionCategoryWaterLayout: UICollectionViewLayout {

    weak var dataSource: CGXCollectionCategoryWaterLayoutDelegate?
    var minimumLineSpacing: CGFloat = 0.0
    /* default 0.0 */
    var minimumInteritemSpacing: CGFloat = 0.0
    /* default 0.0 */
    var sectionHeadersPinToVisibleBounds = false
    // default NO
    var sectionFootersPinToVisibleBounds = false
    
    var itemLayoutAttributes: [[UICollectionViewLayoutAttributes]] = [[UICollectionViewLayoutAttributes]]()
    var headerLayoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var footerLayoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    /// Per section heights.
    var heightOfSections: [NSNumber] = [NSNumber]()
    /// UICollectionView content height.
    var contentHeight: CGFloat = 0.0
    var totalHeight: CGFloat = 0.0
    
    
    override func prepare() {
        super.prepare()
        
        assert(dataSource != nil, "CGXCollectionViewWaterFlowLayout.dataSource cann't be nil.")
        if collectionView!.isDecelerating || collectionView!.isDragging {
            return
        }
        
        contentHeight = 0.0
        itemLayoutAttributes = [[UICollectionViewLayoutAttributes]]()
        headerLayoutAttributes = [UICollectionViewLayoutAttributes]()
        footerLayoutAttributes = [UICollectionViewLayoutAttributes]()
        heightOfSections = [NSNumber]()
        
        let collectionNewView: UICollectionView = collectionView!
        let numberOfSections: Int = collectionNewView.numberOfSections
        let contentInset: UIEdgeInsets = collectionNewView.contentInset
        let contentWidth: CGFloat = collectionNewView.bounds.size.width - contentInset.left - contentInset.right
        
        
        totalHeight = contentInset.top
        
        
        for section in 0..<numberOfSections {
            
            let columnOfSection:Int = (self.dataSource?.collectionWaterView(collectionView!, layout: self, numberOfColumnInSection: section))!
             assert(columnOfSection > 0, "[CGXCollectionViewWaterFlowLayout collectionView:layout:numberOfColumnInSection:] must be greater than 0.");

            let contentInsetOfSection:UIEdgeInsets = self.contentInset(forSection: section)
            let minimumLineSpacing:CGFloat = self.minimumLineSpacing(forSection: section)
            let minimumInteritemSpacing:CGFloat = self.minimumInteritemSpacing(forSection: section)
            
            let contentWidthOfSection:CGFloat = contentWidth - contentInsetOfSection.left - contentInsetOfSection.right
             let itemWidth:CGFloat = (contentWidthOfSection-CGFloat(columnOfSection-1)*minimumInteritemSpacing) / CGFloat(columnOfSection);
            let numberOfItems:Int = collectionView!.numberOfItems(inSection: section)
            
//            // Per section header
            var headerHeight:CGFloat = 0.0;
            
            if dataSource != nil && dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:referenceHeightForHeaderInSection:))) ?? false {
                let headerSize: CGSize? = dataSource?.collectionWaterView!(collectionView!, layout: self, referenceHeightForHeaderInSection: section)
                headerHeight = headerSize!.height
            }
            
            let headerLayoutAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
            headerLayoutAttribute.frame = CGRect(x: 0.0, y: contentHeight, width: contentWidth, height: headerHeight)
            headerLayoutAttributes.append(headerLayoutAttribute)
            
            
            var offsetOfColumns = [CGFloat](repeating: 0.0, count: columnOfSection)
            for i in 0..<columnOfSection {
                offsetOfColumns[i] = headerHeight + contentInsetOfSection.top
            }

            
            /*
             某个分区是否是奇偶瀑布流排布
             */
            
            var isParity:Bool = false
            if dataSource != nil && dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:isParityFlowAtInSection:))) ?? false {
                isParity = (dataSource?.collectionWaterView!(collectionView!, layout: self, isParityFlowAtInSection: section))!
            }
 
            var layoutAttributeOfSection:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
            for item in 0..<numberOfItems {
                
                var currentColumn:Int = 0;
                for i in 0..<columnOfSection {
                    if offsetOfColumns[currentColumn] > offsetOfColumns[i] {
                        currentColumn = i;
                    }
                }
                let indexPath:NSIndexPath = NSIndexPath.init(item: item, section: section)
                if isParity {
                    if dataSource != nil && dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:isParityAItemAt:))) ?? false {
                        currentColumn = (dataSource?.collectionWaterView!(collectionView!, layout: self, isParityAItemAt: indexPath as IndexPath))! ? 1:0
                    }
                }
                let x: CGFloat = contentInsetOfSection.left + CGFloat(itemWidth) * CGFloat(currentColumn) + minimumInteritemSpacing * CGFloat(currentColumn)
                let y: CGFloat = offsetOfColumns[currentColumn] + (item >= columnOfSection ? minimumLineSpacing : 0.0)
                let layoutAttbiture = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                let itemHeight: CGFloat = (dataSource?.collectionWaterView(collectionView!, layout: self, itemWidth: itemWidth, heightForItemAt: indexPath as IndexPath).height)!
                
                layoutAttbiture.frame = CGRect(x: x, y: y + contentHeight, width: itemWidth, height: itemHeight)
                
                layoutAttributeOfSection.append(layoutAttbiture)
                // Update y offset in current column
                offsetOfColumns[currentColumn] = y + itemHeight
            }
            
            itemLayoutAttributes.append(layoutAttributeOfSection)
            
            
            // Get current section height from offset record.
            var maxOffsetValue: CGFloat = offsetOfColumns[0]
            for i in 1..<columnOfSection {
                if offsetOfColumns[i] > maxOffsetValue {
                    maxOffsetValue = offsetOfColumns[i]
                }
            }
            maxOffsetValue += contentInsetOfSection.bottom
            
            
            var footerHeader: CGFloat = 0.0
            if dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:referenceHeightForFooterInSection:))) ?? false {
                let footerSize: CGSize? = dataSource?.collectionWaterView!(collectionView!, layout: self, referenceHeightForFooterInSection: section)
                footerHeader = footerSize?.height ?? 0.0
            }
            let footerLayoutAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
            footerLayoutAttribute.frame = CGRect(x: 0.0, y: contentHeight + maxOffsetValue, width: contentWidth, height: footerHeader)
            footerLayoutAttributes.append(footerLayoutAttribute)
            
            let currentSectionHeight: CGFloat = maxOffsetValue + footerHeader
            heightOfSections.append(NSNumber(value: Float(currentSectionHeight)))
            
            contentHeight += currentSectionHeight

        }
    }
    override var collectionViewContentSize: CGSize {
        let contentInset: UIEdgeInsets = collectionView!.contentInset
        let width: CGFloat = collectionView!.bounds.width - contentInset.left - contentInset.right
        let height = max(collectionView!.bounds.height, contentHeight)
        return CGSize(width: width, height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result: [UICollectionViewLayoutAttributes] = []
      
        for (_, layoutAttributeOfSection) in itemLayoutAttributes.enumerated() {
            let sectionArr:[UICollectionViewLayoutAttributes] = layoutAttributeOfSection
            for (_, attribute) in sectionArr.enumerated() {
                    if attribute.frame.size.height != 0 && rect.intersects(attribute.frame) {
                        result.append(attribute)
                    }
            }
        }
        for (_, attribute) in headerLayoutAttributes.enumerated() {
            if attribute.frame.size.height != 0 && rect.intersects(attribute.frame) {
                    result.append(attribute)
            }
        }
        for (_, attribute) in footerLayoutAttributes.enumerated() {
            if attribute.frame.size.height != 0 && rect.intersects(attribute.frame) {
                    result.append(attribute)
            }
        }
        if sectionHeadersPinToVisibleBounds {
            for attriture in result {
                if !(attriture.representedElementKind == UICollectionView.elementKindSectionHeader) {
                    continue
                }
                let section: Int = attriture.indexPath.section
                let contentInsetOfSection: UIEdgeInsets = contentInset(forSection: section)
                let firstIndexPath = IndexPath(item: 0, section: section)
                let itemAttribute: UICollectionViewLayoutAttributes? = layoutAttributesForItem(at: firstIndexPath)
                let headerHeight: CGFloat = attriture.frame.height
                var frame: CGRect = attriture.frame
                frame.origin.y = min(max(collectionView!.contentOffset.y, (CGFloat)((itemAttribute?.frame.minY)!) - headerHeight - contentInsetOfSection.top), (CGFloat)((itemAttribute?.frame.minY)!) + (CGFloat)(truncating: heightOfSections[section]))
                attriture.frame = frame
                attriture.zIndex = (NSInteger.max / 2) + section
            }
        }
        
        if sectionFootersPinToVisibleBounds {
            for attriture in result {
                if !(attriture.representedElementKind == UICollectionView.elementKindSectionFooter) {
                    continue
                }
                let section: Int = attriture.indexPath.section
                let contentInsetOfSection: UIEdgeInsets = contentInset(forSection: section)
                let firstIndexPath = IndexPath(item: 0, section: section)
                let itemAttribute: UICollectionViewLayoutAttributes? = layoutAttributesForItem(at: firstIndexPath)
                let headerHeight: CGFloat = attriture.frame.height
                var frame: CGRect = attriture.frame
                frame.origin.y = min(max(collectionView!.contentOffset.y, (CGFloat)((itemAttribute?.frame.minY)!) - headerHeight - contentInsetOfSection.top), (CGFloat)((itemAttribute?.frame.minY)!) + (CGFloat)(truncating: heightOfSections[section]))
                attriture.frame = frame
                attriture.zIndex = (NSInteger.max / 2) + section
            }
        }
        return result
    }

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributes[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if (elementKind == UICollectionView.elementKindSectionHeader) {
            return headerLayoutAttributes[indexPath.item]
        }
        if (elementKind == UICollectionView.elementKindSectionFooter) {
            return footerLayoutAttributes[indexPath.item]
        }
        return nil
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

/**
 *  MARK: - 间距配置
 **/
extension  CGXCollectionCategoryWaterLayout {
    
    func contentInset(forSection section: Int) -> UIEdgeInsets {
        var edgeInsets: UIEdgeInsets = .zero
        if dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:insetForSectionAt:))) ?? false {
            if let collection:UIEdgeInsets = dataSource?.collectionWaterView!(collectionView!, layout: self, insetForSectionAt: section) {
                edgeInsets = collection
            }
        }
        return edgeInsets
    }
    func minimumLineSpacing(forSection section: Int) -> CGFloat {
        var minimumLineSpacing: CGFloat = self.minimumLineSpacing
        if dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:minimumLineSpacingForSectionAt:))) ?? false {
            minimumLineSpacing = dataSource?.collectionWaterView!(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? 0.0
        }
        return minimumLineSpacing
    }
    
    func minimumInteritemSpacing(forSection section: Int) -> CGFloat {
        var minimumInteritemSpacing: CGFloat = self.minimumInteritemSpacing
        if dataSource?.responds(to: #selector(CGXCollectionCategoryWaterLayoutDelegate.collectionWaterView(_:layout:minimumInteritemSpacingForSectionAt:))) ?? false {
            minimumInteritemSpacing = dataSource?.collectionWaterView!(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? 0.0
        }
        return minimumInteritemSpacing
    }
}

/**
 *  MARK: - 定义代理方法
**/
@objc protocol CGXCollectionCategoryWaterLayoutDelegate: NSObjectProtocol {
    /// Return per section's column number(must be greater than 0).
    func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, numberOfColumnInSection section: Int) -> Int
    /// Return per item's height   高度设置无效 等宽的
    func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, itemWidth width: CGFloat, heightForItemAt indexPath: IndexPath) -> CGSize
    
    /// Column spacing between columns
    //   此方法排列方式  偶数下标在左边。奇数下标在右边。   两列情况下使用
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, isParityAItemAt indexPath: IndexPath) -> Bool
    /*
     某个分区是否是奇偶瀑布流排布
     */
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, isParityFlowAtInSection section: Int) -> Bool
    /// Column spacing between columns
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    /// The spacing between rows and rows
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    /// Return per section header view height.
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, referenceHeightForHeaderInSection section: Int) -> CGSize
    /// Return per section footer view height.
    @objc optional func collectionWaterView(_ collectionView: UICollectionView, layout: CGXCollectionCategoryWaterLayout, referenceHeightForFooterInSection section: Int) -> CGSize
}

