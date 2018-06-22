//
//  Photos.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/16/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
    
    static func initial() -> Photos {
        return Photos(page: 1,
                      pages: 0,
                      perpage: 30,
                      total: 0,
                      photo: [])
    }
    
    func from(new newPhotos: Photos) -> Photos {
        return newPhotos.page == 1 && newPhotos.photo.count == 0 ? newPhotos :
            Photos(page: newPhotos.page + 1,
                     pages: newPhotos.pages,
                     perpage: newPhotos.perpage,
                     total: newPhotos.total,
                     photo: newPhotos.page == 1 ? newPhotos.photo : photo + newPhotos.photo)
    }
}
