//
//  ReactiveExtensions.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let yOffset = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return yOffset > threshold ? Observable.just(()) : Observable.empty()
        }
        
        return ControlEvent(events: observable)
    }
}

public extension ObserverType {
    
    public func onNextAndCompleted(_ element: Self.E) {
        onNext(element)
        onCompleted()
    }
}
