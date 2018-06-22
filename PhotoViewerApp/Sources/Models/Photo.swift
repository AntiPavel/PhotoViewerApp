//
//  Photo.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct Description: Decodable {
    let content: String?
    private enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

struct Photo: Decodable {
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ownername: String?
    let description: Description?
}
