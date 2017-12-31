//
//  PhotoListViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/29.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var gid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.size.width / 3
        return CGSize(width: size, height: size)
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.gid == nil {
            return ShopPhoto.sharedInstance.gids.count
        }

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.gid == nil {
            return ShopPhoto.sharedInstance.numberOfPhotos(in: section)
        }

        return ShopPhoto.sharedInstance.count(gid: gid!)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListItem", for: indexPath) as! PhotoListItemCollectionViewCell

        if self.gid == nil {
            let gid = ShopPhoto.sharedInstance.gids[indexPath.section]
            cell.photo.image = ShopPhoto.sharedInstance.image(gid: gid, index: indexPath.row)
        } else {
            cell.photo.image = ShopPhoto.sharedInstance.image(gid: self.gid!, index: indexPath.row)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "PhotoListHeader",
                for: indexPath
            ) as! PhotoListItemCollectionViewHeader

            if self.gid == nil {
                let gid = ShopPhoto.sharedInstance.gids[indexPath.section]
                header.title.text = ShopPhoto.sharedInstance.names[gid]
            } else {
                header.title.text = ShopPhoto.sharedInstance.names[self.gid!]
            }

            return header
        }

        return UICollectionReusableView()
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PushPhotoDetail", sender: indexPath)
    }
}

extension PhotoListViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushPhotoDetail" {
            let vc = segue.destination as! PhotoDetailViewController

            if let indexPath = sender as? IndexPath {
                if self.gid == nil {
                    let gid = ShopPhoto.sharedInstance.gids[indexPath.section]
                    let image = ShopPhoto.sharedInstance.image(gid: gid, index: indexPath.row)
                    vc.image = image
                } else {
                    let image = ShopPhoto.sharedInstance.image(gid: gid!, index: indexPath.row)
                    vc.image = image
                }
            }
        }
    }
}
