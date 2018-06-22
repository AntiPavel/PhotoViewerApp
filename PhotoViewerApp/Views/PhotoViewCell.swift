//
//  PhotoViewCell.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import TinyConstraints
import Kingfisher

class PhotoViewCell: UICollectionViewCell {
    
    static var cellHeight: CGFloat {
        return 44
    }
    
    private let imageHeight: CGFloat = 150
    private let imageWidth: CGFloat = 150
    private let horizontalOffset: CGFloat = 12
    private let verticalOffset: CGFloat = 8
    
    let titleLabel = UILabel()
    let ownerLabel = UILabel()
    let detailLabel = UILabel()
    let mainImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        addConstraints()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.width(UIScreen.main.bounds.width - 10)
        contentView.backgroundColor = .lightGray
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(mainImageView)
    }
    
    private func addConstraints() {
        mainImageView.leftToSuperview(offset: horizontalOffset)
        mainImageView.width(imageWidth)
        mainImageView.height(imageHeight)
        mainImageView.topToSuperview(offset: verticalOffset)
        mainImageView.bottomToSuperview(offset: -verticalOffset)
        mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
        
        titleLabel.leftToRight(of: mainImageView, offset: horizontalOffset)
        titleLabel.rightToSuperview(offset: horizontalOffset)
        titleLabel.topToSuperview(offset: verticalOffset)
        titleLabel.numberOfLines = 5
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        ownerLabel.leftToRight(of: mainImageView, offset: horizontalOffset)
        ownerLabel.rightToSuperview(offset: horizontalOffset)
        ownerLabel.topToBottom(of: titleLabel, offset: verticalOffset)
        ownerLabel.numberOfLines = 1
        ownerLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)

        detailLabel.leftToRight(of: mainImageView, offset: horizontalOffset)
        detailLabel.rightToSuperview(offset: horizontalOffset)
        detailLabel.numberOfLines = 3
        detailLabel.topToBottom(of: ownerLabel, offset: verticalOffset)
        detailLabel.bottomToSuperview(offset: -verticalOffset, relation: .equalOrGreater)
        detailLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
    }
    
    private let placeholderImage = UIImage(named: "flickr.png")
    
    var viewModel: PhotoDetailViewModel? {
        didSet {
            mainImageView.image = placeholderImage
            titleLabel.text = viewModel?.title
            if let urlString = viewModel?.urlToImage,
                let url = URL(string: urlString) {
                    mainImageView.kf.setImage(with: url, placeholder: placeholderImage)
                }
            ownerLabel.text = viewModel?.owner
            detailLabel.text = viewModel?.description != "" ? viewModel?.description : "no description"
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = super.preferredLayoutAttributesFitting(layoutAttributes)
        var frame = attr.frame
        frame.size.width = layoutAttributes.size.width
        attr.frame = frame
        return attr
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        mainImageView.image = placeholderImage
    }
    
}
