//
//  NSObjectExtensions.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
