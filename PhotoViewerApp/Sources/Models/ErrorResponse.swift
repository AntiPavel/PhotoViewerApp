//
//  ErrorResponse.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    
    let stat: String
    let code: Int
    let message: String
}
