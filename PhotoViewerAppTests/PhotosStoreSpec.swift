//
//  PhotosStoreSpec.swift
//  PhotoViewerAppTests
//
//  Created by Antonov, Pavel on 6/21/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//
import Quick
import Nimble
import RxBlocking
import Mockingjay
@testable import PhotoViewerApp

class PhotosStoreSpec: QuickSpec {
    override func spec() {
        describe("PhotosStore") {
            var store: PhotosStore!
            beforeSuite {
                store = PhotosStore(networkService: NetworkService())
            }
            
            it("should return object without errors") {
                expect(store.photos.value.page).to(equal(1))
            }
        
            it("should return object without errors") {
                store.loadNextPageTrigger.onNext(())
                expect(store.photos.value.page).toEventually(equal(2), timeout: 5.0)
            }
            
            it("should return object without errors") {
                store.loadNextPageTrigger.onNext(())
                expect(store.isLoading.value).to(equal(true))
                expect(store.photos.value.page).toEventually(equal(2), timeout: 3.0)
            }
            
            it("should return object without errors") {
                store.loadNextPageTrigger.onNext(())
                var shouldLoad = true
                _ = store.isLoading.subscribe(onNext: { isLoading in
                    if !isLoading && shouldLoad {
                        store.loadNextPageTrigger.onNext(())
                        shouldLoad = false
                    }
                })
                expect(store.photos.value.page).toEventually(equal(4), timeout: 5.0)
            }
            
            it("should return object without errors") {
                store.refreshTrigger.onNext(())
                expect(store.photos.value.page).toEventually(equal(2), timeout: 3.0)
            }
            
            it("should return object without errors") {
                let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error description"])
                self.stub(http(.get, uri: "/services/rest"), failure(error))
                store.loadNextPageTrigger.onNext(())
                waitUntil { done in
                    _ = store.error.subscribe(onNext: { error in
                        expect(error.localizedDescription).to(equal("Error description"))
                        done()
                    })
                }
            }
            
        }
    }
}
