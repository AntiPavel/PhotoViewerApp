//
//  PhotoDetailViewModel.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct PhotoDetailViewModel {
    
    let owner: String?
    let title: String?
    let urlToImage: String?
    
    init(photo: Photo) {
        owner = photo.owner
        title = photo.title
        urlToImage = "https://farm\(photo.farm ?? 1).staticflickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
    }
}
