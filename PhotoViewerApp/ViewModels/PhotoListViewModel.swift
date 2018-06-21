//
//  PhotoListViewModel.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RxSwift

struct PhotoListViewModel {
    
    private let photosStore: PhotosStore
    
    init(store: PhotosStore) {
        photosStore = store
    }
    
    var photoArray: Observable<[PhotoDetailViewModel]> {
        return self.photosStore.photos.map({ $0.photo.map({ PhotoDetailViewModel(photo: $0)}) })
    }
    
    var loadNextPageTrigger: PublishSubject<Void> {
        return photosStore.loadNextPageTrigger
    }
    
    var refreshTrigger: PublishSubject<Void> {
        return photosStore.refreshTrigger
    }
    
    var error: PublishSubject<Error> {
        return photosStore.error
    }
    
}
