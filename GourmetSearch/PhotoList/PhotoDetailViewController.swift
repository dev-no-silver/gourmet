//
//  PhotoDetailViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/30.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!

    var image: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.photo.alpha = 0
        self.photo.image = image
    }

    override func viewDidLayoutSubviews() {
        scrollView.contentInset.top = (scrollView.bounds.size.height - photo.bounds.size.height) / 2.0
        scrollView.contentInset.bottom = (scrollView.bounds.size.height - photo.bounds.size.height) / 2.0

        scrollView.setZoomScale(1, animated: true)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3

        self.view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.photo.alpha = 1
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension PhotoDetailViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photo
    }
}
