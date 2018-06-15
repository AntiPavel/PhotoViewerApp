//
//  Photo.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    struct Source: Decodable {
        let name: String?
    }
    
    let source: Source?
    let info: String?
    let camera: String?
    let lens: String?
    let focalLength: String?
    let iso: String?
    let shutterSpeed: String?
    let highest_rating: Double?
    let imageurl: String?
}
