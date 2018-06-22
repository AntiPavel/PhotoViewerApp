//
//  PhotoListViewController.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import TinyConstraints
import RxCocoa
import RxSwift

protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView { get }
}

final class PhotoListViewController: UIViewController, CollectionPushAndPoppable {
    
    var sourceCell: UICollectionViewCell?
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let disposeBag = DisposeBag()
    private var viewModel: PhotoListViewModel
    
    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAndConfigureTableView()
        addRefreshControl()
        bindViewModel()
        addSubscriberToItemSelected()
        addSubscriberForNextPageLoading()
        addSubscriberToError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    private func addAndConfigureTableView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 10, height: 1)
        }
        collectionView.register(PhotoViewCell.self,
                                forCellWithReuseIdentifier: PhotoViewCell.className)
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        viewModel.photoArray.subscribe ({_ in
            refreshControl.endRefreshing()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel
            .photoArray
            .bind(to: collectionView.rx.items(cellIdentifier: PhotoViewCell.className,
                                              cellType: PhotoViewCell.self)) { $2.viewModel = $1 }
            .disposed(by: disposeBag)
    }
    
    private func addSubscriberToItemSelected() {
        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(PhotoDetailViewModel.self))
            .bind { [unowned self] indexPath, model in
                guard let cell  = self.collectionView.cellForItem(at: indexPath) as? PhotoViewCell else {
                    return
                }
                self.sourceCell = cell
                let detailViewController = DetailViewController()
                detailViewController.setup(with: model)
                detailViewController.loadViewIfNeeded()
                self.navigationController?.delegate = self
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func addSubscriberForNextPageLoading() {
        collectionView.rx.reachedBottom
            .map { _ in () }
            .bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
    }
    
    private func addSubscriberToError() {
        viewModel.error.subscribe {  [weak self] event in
            switch event {
            case .next(let error),
                 .error(let error):
                self?.showAlertController(message: error.localizedDescription)
            case .completed:
                break
            }
            }.disposed(by: disposeBag)
    }
    
    private func showAlertController(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PhotoListViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimator(operation: operation)
    }
}
