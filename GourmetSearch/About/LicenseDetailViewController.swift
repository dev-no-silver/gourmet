//
//  LicenseDetailViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2018/01/01.
//  Copyright © 2018年 Yasunari Kondo. All rights reserved.
//

import UIKit

class LicenseDetailViewController: UIViewController {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var textHeight: NSLayoutConstraint!

    var name = ""
    var license = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.text.text = self.license
        self.title = self.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        let frame = CGSize(width: self.text.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        self.textHeight.constant = self.text.sizeThatFits(frame).height

        self.view.layoutIfNeeded()
    }
}
