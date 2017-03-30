//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Pattanashetty, Sadananda on 3/29/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var url: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImageWith((URL(string: url!)!))
    }



}
