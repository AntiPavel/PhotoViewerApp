//
//  SuccessResponse.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct SuccessResponse: Decodable {
    
    let stat: String
    let photos: Photos
}
