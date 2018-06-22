//
//  CustomAnimator.swift
//  PhotoViewerApp
//
//  Created by Antonov, Pavel on 6/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import UIKit

final class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let operationType: UINavigationControllerOperation
    private let transitionDuration: TimeInterval
    
    init(operation: UINavigationControllerOperation) {
        operationType = operation
        transitionDuration = 0.7
    }
    
    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        operationType = operation
        transitionDuration = duration
    }
    
    internal func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            fatalError("Transition impossible to perform since either the destination view or the conteiner view are missing!")
        }
        
        let container = transitionContext.containerView
        
        guard let fromViewController = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.from) as? CollectionPushAndPoppable,
            let currentCell = fromViewController.sourceCell as? PhotoViewCell else {
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        container.addSubview(toView)
        
        let screenshotToView =  UIImageView(image: toView.screenshot)
        screenshotToView.frame = currentCell.mainImageView.frame
        
        let containerCoord = currentCell.convert(screenshotToView.frame.origin, to: container)
        screenshotToView.frame.origin = containerCoord
        
        let screenshotFromView = UIImageView(image: currentCell.mainImageView.screenshot)
        screenshotFromView.frame = currentCell.mainImageView.frame
        screenshotFromView.frame.origin = containerCoord
        
        container.addSubview(screenshotToView)
        container.addSubview(screenshotFromView)
        
        toView.isHidden = true
        screenshotToView.isHidden = true
        
        let delayTime = DispatchTime.now() + Double(Int64(0.08 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            screenshotToView.isHidden = false
        }
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
        animations: {
            screenshotFromView.alpha = 0.0
            screenshotToView.frame = UIScreen.main.bounds
            screenshotToView.frame.origin = CGPoint(x: 0.0, y: 0.0)
            screenshotFromView.frame = screenshotToView.frame
        }, completion: {
            if $0 {
                screenshotToView.removeFromSuperview()
                screenshotFromView.removeFromSuperview()
                toView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        })
    }
    
    internal func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            fatalError("Transition impossible to perform since either the destination view or the conteiner view are missing!")
        }
        
        let container = transitionContext.containerView
        
        guard let toViewController = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.to) as? CollectionPushAndPoppable,
            let fromViewController = transitionContext
                .viewController(forKey: UITransitionContextViewControllerKey.from) as? DetailViewController,
            let fromView = fromViewController.imageView,
            let currentCell = toViewController.sourceCell  as? PhotoViewCell else {
                container.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        let containerCoord = currentCell.convert(currentCell.mainImageView.frame.origin, to: container)
        
        container.addSubview(toView)
        
        let screenshotFromView = UIImageView(image: fromView.screenshot)
        screenshotFromView.frame = fromView.frame
        
        let screenshotToView = UIImageView(image: currentCell.mainImageView.screenshot)
        screenshotToView.frame = screenshotFromView.frame
        
        container.addSubview(screenshotToView)
        container.insertSubview(screenshotFromView, belowSubview: screenshotToView)
        
        screenshotToView.alpha = 0.0
        fromView.isHidden = true
        
        UIView.animate(withDuration: transitionDuration, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: [],
        animations: {
            screenshotToView.alpha = 1.0
            screenshotFromView.frame = currentCell.mainImageView.frame
            screenshotFromView.frame.origin = containerCoord
            screenshotToView.frame = screenshotFromView.frame
        }, completion: {
            if $0 {
                currentCell.isHidden = false
                screenshotFromView.removeFromSuperview()
                screenshotToView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operationType == .push {
            performPushTransition(transitionContext)
        } else if operationType == .pop {
            performPopTransition(transitionContext)
        }
    }
}
