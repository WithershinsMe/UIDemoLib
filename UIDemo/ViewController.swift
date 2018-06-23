//
//  ViewController.swift
//  UIDemo
//
//  Created by GK on 2018/6/18.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listView: UIScrollView!
    var selectedImage: Indredients?
    var selectedModel: IndredientModel?
    
    let herbs = IndredientModel.all()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if listView.subviews.count < herbs.count {
            listView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
            setupList()
        }
    }

    func setupList() {
        
        for i in herbs.indices {
            
            let model = herbs[i]
            
            let indredientView = Indredients()
            indredientView.tag = i + 1001
            indredientView.imageView.image = UIImage(named: model.imageName)
            indredientView.titleLabel.text = model.title
            indredientView.subTitleLabel.text = model.subTitle
            
            //create image view
            indredientView.layer.cornerRadius = 5.0
            indredientView.layer.masksToBounds = true
            listView.addSubview(indredientView)
            
            //attach tap detector
            indredientView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        }
        
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight * 1.33
        let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let itemWidth: CGFloat = itemHeight / aspectRatio
        
        let horizontalPadding: CGFloat = 10.0
        
        for i in herbs.indices {
            let tag = i + 1001
            let castView = (listView.viewWithTag(tag)) as! Indredients
            castView.frame = CGRect(
                x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0,
                width: itemWidth, height: itemHeight)
        }
        
        listView.contentSize = CGSize(
            width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding,
            height:  0)
    }
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        if let selectedView = tap.view as? Indredients {
            self.selectedImage = selectedView
            let tag = selectedView.tag - 1001
            if tag >= 0 && tag < (herbs.count - 1) {
                self.selectedModel = herbs[tag]
                performSegue(withIdentifier: "ShowDetail", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowDetail" {
            if let detailVC = segue.destination as? IndredientDetailViewController {
               detailVC.indredientModel = self.selectedModel
                detailVC.transitioningDelegate = self
            }
        }
        
    }
}
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let originFrame = selectedImage?.convert(selectedImage?.imageView.frame ?? CGRect.zero, to: self.view)
        self.selectedImage?.imageView.isHidden = true;
        let transition = PresentAnimationController(originFrame: originFrame!)
        transition.dismissCompletion = { [weak self] in
            self?.selectedImage?.imageView.isHidden = false;
        }
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? IndredientDetailViewController else {
            return nil
        }
        if let selectedImageView = self.selectedImage {
            let destinationFrame = selectedImageView.convert(selectedImageView.imageView.frame, to: self.view)

            let snapView = revealVC.imageView
            
            let transition = DismissAnimationController(destinationFrame: destinationFrame,snapshotView: snapView);
            selectedImageView.imageView.isHidden = true;
            transition.dismissCompletion = { [weak self] in
                self?.selectedImage?.imageView.isHidden = false;
            }
            return transition
        }
        return nil
    }
}

