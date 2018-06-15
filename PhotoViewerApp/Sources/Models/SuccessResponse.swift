//
//  SuccessResponse.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct SuccessResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Photo]
}
