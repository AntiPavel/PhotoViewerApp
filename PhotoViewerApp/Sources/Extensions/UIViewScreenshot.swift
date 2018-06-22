//
//  UIViewScreenshot.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        guard let contex = UIGraphicsGetCurrentContext() else {
            return nil
        }
        if let tableView = self as? UITableView {
            tableView.superview?.layer.render(in: contex)
        } else {
            layer.render(in: contex)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
