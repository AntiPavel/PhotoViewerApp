//
//  Photo.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    struct Description: Decodable {
        let _content: String?
    }
    
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ownername: String?
    let description: Description?
}
