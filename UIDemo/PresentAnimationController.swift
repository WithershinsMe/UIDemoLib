//
//  ViewController.swift
//  UIDemo
//
//  Created by GK on 2018/6/18.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let originFrame: CGRect
  var dismissCompletion: (()->Void)?

  init(originFrame: CGRect) {
    self.originFrame = originFrame
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let toVC = transitionContext.viewController(forKey: .to),
      let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
      else {
        return
    }
    
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    snapshot.frame = originFrame
    snapshot.layer.cornerRadius = 5
    snapshot.layer.masksToBounds = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot)
    toVC.view.isHidden = true
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
      snapshot.frame = finalFrame
    }) { _ in
      toVC.view.isHidden = false
      snapshot.removeFromSuperview()
      if (self.dismissCompletion != nil) {
        self.dismissCompletion?()
      }
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

  }
}
