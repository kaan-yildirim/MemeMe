//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by KAAN YILDIRIM on 26.11.2021.
//

import UIKit

final class MemeDetailViewController: UIViewController {

    @IBOutlet private weak var memeImageView: UIImageView!
    var meme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme?.memeImage
    }
}
