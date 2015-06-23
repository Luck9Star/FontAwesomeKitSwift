//
//  SecondViewController.swift
//  Example
//
//  Created by Ethan Yang on 15/6/23.
//  Copyright © 2015年 Ethan Yang. All rights reserved.
//

import UIKit
import FontAwesomeKitSwift
class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = Icon.icons(FoundationIcons.Trees,Zocial.Amazon)(size: 100)(color: nil).imageWithSize(CGSize(width: 240, height: 120))
        imageView.image = image;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

