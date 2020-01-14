//
//  PoiImageCollectionViewLayout.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

class PoiImageCollectionViewLayout: UICollectionViewLayout {
    var _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var _contentSize = CGSize.zero
    
    override func prepare() {
        super.prepare()
        
        _layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        
        let width = collectionView!.frame.size.width
        let height = collectionView!.frame.size.height
        
        var yOffset: CGFloat = 0.0
        var xOffset: CGFloat = 0.0
        
        let section = 0
        let numberOfItems = collectionView!.numberOfItems(inSection: section)
        
        for item in 0 ..< numberOfItems {
            
            let indexPath = IndexPath(item: item, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: xOffset, y: yOffset, width: width / 3, height: height).integral
            let key = layoutKeyForIndexPath(indexPath)
            _layoutAttributes[key] = attributes
            
            xOffset += (width / 3 + 10)
        }
        
        yOffset = height
        
        _contentSize = CGSize(width: xOffset, height: yOffset)
    }
    
    func layoutKeyForIndexPath(_ indexPath : IndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    override var collectionViewContentSize: CGSize {
        return _contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let key = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[key]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self._layoutAttributes[evaluatedObject as! String]
            return rect.intersects(layoutAttribute!.frame)
        }
        
        let dict = _layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filtered(using: predicate)
        
        return dict.objects(forKeys: matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
}
