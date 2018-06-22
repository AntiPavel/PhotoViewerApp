//
//  JsonFileReader.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/21/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

func readFile(fileName: String) -> Data {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
        fatalError("Error while reading the json file")
    }
    guard let data = try? NSData(contentsOfFile: path) as Data else {
        fatalError("Error while creating data from the path")
    }
    return data
}
