//
//  PoiImageCollectionViewCell.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit
import Kingfisher

class PoiImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.clipsToBounds = true
    }
    
    func configureCell(url: String?) {
        self.configure(resourceUrl: url)
    }
    
    private func configure(resourceUrl: String?) {
        imageView.image = nil
        
        let optionsInfo: [KingfisherOptionsInfoItem] = [.transition(ImageTransition.fade(0.3))]
        if let resourceUrl = resourceUrl, let url = URL(string: resourceUrl) {
            let resource = ImageResource(downloadURL: url, cacheKey: resourceUrl)

            imageView.kf.setImage(with: resource, options: optionsInfo) { result in
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                case .failure(_):
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
