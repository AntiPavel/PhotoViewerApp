//
//  DetailViewController.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/20/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    private let placeholderImage = UIImage(named: "flickr.png")
    private var viewModel: PhotoDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        titleLabel.text = viewModel?.owner
        infoLabel.text = viewModel?.description != "" ? viewModel?.description : "no description"
        infoLabel.sizeToFit()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        imageView.image = placeholderImage
        if let urlString = viewModel?.urlToImage,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: placeholderImage) { [weak self] (image, _, _, _) in
                self?.setImageAndLabels(image: image)
            }
        }
    }
    
    func setup(with viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func setImageAndLabels(image: UIImage?) {
        guard let image = image else {
            return
        }
        var scale: CGFloat = 1
        if image.size.width < UIScreen.main.bounds.width {
            scale = UIScreen.main.bounds.width / image.size.width
            scrollView.zoomScale = 1.0 * scale
            scrollView.maximumZoomScale = 4 * scale
        }
        titleLabel.height(titleLabel.bounds.height, isActive: true)
        infoLabel.height(infoLabel.bounds.height, isActive: true)
        scrollView.height(image.size.height * scale)
        view.layoutIfNeeded()
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
