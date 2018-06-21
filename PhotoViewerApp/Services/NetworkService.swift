//
//  NetworkService.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

public struct NetworkService {
    
    func loadData(with initialPhotos: Photos) -> Observable<Photos> {
        return Observable<Photos>.create { observer in
            let request = Alamofire.request(Router.getRecentPhotos(fetchRequest: .args(page: initialPhotos.page, perPage: initialPhotos.perpage)))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let successResponse = try? JSONDecoder().decode(SuccessResponse.self, from: data) {
                            observer.onNextAndCompleted(successResponse.photos)
                        } else {
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onError(NSError(domain: "Server Error Code: \(errorResponse.code)",
                                                         code: -1001,
                                                         userInfo: [NSLocalizedDescriptionKey: errorResponse.message]))
                            } catch {
                                observer.onError(error)
                            }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    
    private enum Router: URLRequestConvertible {
        
        case getRecentPhotos(fetchRequest: FetchRequest)
        
        var method: HTTPMethod {
            switch self {
            case .getRecentPhotos:
                return .get
            }
        }
        
        var apiMethod: String {
            switch self {
            case .getRecentPhotos:
                return "flickr.photos.getRecent"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            
            let url = try Api.baseURLString.asURL()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getRecentPhotos(let fetchRequest):
                var parameters = fetchRequest.parameters
                parameters["method"] = apiMethod
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
            
            return urlRequest
        }
        
    }
    
    private enum FetchRequest {
        
        case args(page: Int, perPage: Int)
        
        var parameters: Parameters {
            if case .args(let page, let perPage) = self {
                return [
                        "per_page": perPage,
                        "page": page,
                        "api_key": Api.key,
                        "format":"json",
                        "nojsoncallback":1,
                ]
            }
            return [:]
        }
    }
    
    private struct Api {
        static let baseURLString = "https://api.flickr.com/services/rest"
        static let key = "c850f41e3b6379b8b2f1bdcf03eb36a7"
    }
}
