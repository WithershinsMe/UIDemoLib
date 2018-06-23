//
//  IndredientDetailViewController.swift
//  UIDemo
//
//  Created by GK on 2018/6/18.
//  Copyright © 2018年 com.gk. All rights reserved.
//

import UIKit

class IndredientDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var indredientModel: IndredientModel?
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView.image = UIImage(named: indredientModel != nil ? indredientModel!.imageName: "")
        self.titleLabel.text = indredientModel?.title
        self.subTitle.text = indredientModel?.subTitle
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
