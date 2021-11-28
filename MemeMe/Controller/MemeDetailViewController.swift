//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by KAAN YILDIRIM on 26.11.2021.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var meme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme?.memeImage
    }
}
