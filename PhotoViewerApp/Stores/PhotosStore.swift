//
//  PhotosStore.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class PhotosStore {
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let photos = BehaviorRelay<Photos>(value: Photos.initial())
    let error = PublishSubject<Error>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        let refreshRequest = isLoading
            .asObservable()
            .sample(refreshTrigger)
            .flatMap { $0 ? Observable.empty() :
                Observable<Photos>.create { observer in
                    observer.onNextAndCompleted(Photos.initial())
                    return Disposables.create()
                }
        }
        
        let nextPageRequest = isLoading
            .asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { $0 ? Observable.empty() :
                Observable<Photos>.create { observer in
                    observer.onNextAndCompleted(self.photos.value)
                    return Disposables.create()
                }
        }
        
        let request = Observable
            .of(refreshRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { [weak self] in
            self?.networkService.loadData(with: $0)
            .do(onError: { [weak self] in
                self?.error.onNext($0)
            })
            .catchError { _ in Observable.empty() } ?? Observable.empty()
        }.share(replay: 1)
        
        Observable
            .combineLatest(photos, response) { $0.from(new: $1) }
            .sample(response)
            .bind(to: photos)
            .disposed(by: disposeBag)
        
        Observable
            .of(request.map { _ in true },
                response.map { _ in false },
                error.map { _ in false }
            )
            .merge()
            .bind(to: isLoading)
            .disposed(by: disposeBag)
    }
}
