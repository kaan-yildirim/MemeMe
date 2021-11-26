//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by KAAN YILDIRIM on 26.11.2021.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memeList
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
