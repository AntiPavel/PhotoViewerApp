//
//  ErrorResponse.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: String
    let code: String
    let info: String
}
