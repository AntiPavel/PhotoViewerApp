//
//  PhotoViewerAppTests.swift
//  PhotoViewerAppTests
//
//  Created by Antonov, Pavel on 6/14/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Quick
import Nimble
@testable import PhotoViewerApp

class PhotosSpec: QuickSpec {
    override func spec() {
        describe("Photos") {
            
            it("all data should parse correctly") {
                let data = readFile(fileName: "PhotosMock")
                let decodablePhotos = try? JSONDecoder().decode(Photos.self, from: data)
                expect(decodablePhotos?.page).to(equal(1))
                expect(decodablePhotos?.pages).to(equal(34))
                expect(decodablePhotos?.perpage).to(equal(30))
                expect(decodablePhotos?.total).to(equal(1000))
                expect(decodablePhotos?.photo.count).to(equal(30))
            }
            
            context("initialization") {
                it("should return initial values") {
                    let photos = Photos.initial()
                    expect(photos.page).to(equal(1))
                    expect(photos.pages).to(equal(0))
                    expect(photos.perpage).to(equal(30))
                    expect(photos.total).to(equal(0))
                    expect(photos.photo.count).to(equal(0))
                }
            }
        }
    }
}
