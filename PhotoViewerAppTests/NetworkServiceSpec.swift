//
//  NetworkServiceSpec.swift
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

class NetworkServiceSpec: QuickSpec {
    override func spec() {
        describe("NetworkService") {
            var networkService: NetworkService!
            beforeEach {
                networkService = NetworkService()
            }
            
            it("should return object without errors") {
                let result = networkService.loadData(with: Photos.initial())
                    .toBlocking(timeout: 3.0)
                    .materialize()
                
                switch result {
                case .completed(let photos):
                    expect(photos.first?.photo.count).to(equal(30))
                case .failed(_, let error):
                    fail("Expected result to complete without error, but received \(error).")
                }
            }
            
            it("should fail with network error") {
                let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error description"])
                self.stub(http(.get, uri: "/services/rest"), failure(error))

                let result = networkService.loadData(with: Photos.initial())
            
                waitUntil { done in
                    _ = result.subscribe(onError: { error in
                        expect(error.localizedDescription).to(equal("Error description"))
                        done()
                    })
                }
            }
            
            it("should fail with parse error") {
                let wrongJson = ["stat": "Error", "code": 404, "message": "Error message"] as [String: Any]
                self.stub(http(.get, uri: "/services/rest"), json(wrongJson))

                let result = networkService.loadData(with: Photos.initial())
                    .toBlocking(timeout: 3.0)
                    .materialize()

                switch result {
                case .completed:
                    fail("should't return result")
                case .failed(_, let error):
                    expect((error as NSError).domain).to(equal("Server Error Code: 404"))
                    expect(error.localizedDescription).to(equal("Error message"))
                }
            }

            it("should fail with missing data error") {
                let wrongJson = ["wrongKey": "wrongValue"] as [String: Any]
                self.stub(http(.get, uri: "/services/rest"), json(wrongJson))

                let result = networkService.loadData(with: Photos.initial())
                    .toBlocking(timeout: 3.0)
                    .materialize()

                switch result {
                case .completed:
                    fail("should't return result")
                case .failed(_, let error):
                    expect((error as NSError).domain).to(equal("NSCocoaErrorDomain"))
                    expect(error.localizedDescription).to(equal("The data couldn’t be read because it is missing."))
                }
            }
            
        }
    }
}
