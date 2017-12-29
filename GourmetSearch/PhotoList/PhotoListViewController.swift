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
        let size = self.view.frame.width / 3
        return CGSize(width: size, height: size)
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ShopPhoto.sharedInstance.gids.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShopPhoto.sharedInstance.numberOfPhotos(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListItem", for: indexPath) as! PhotoListItemCollectionViewCell

        let gid = ShopPhoto.sharedInstance.gids[indexPath.section]
        cell.photo.image = ShopPhoto.sharedInstance.image(gid: gid, index: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "PhotoListHeader",
                for: indexPath
            ) as! PhotoListItemCollectionViewHeader

            let gid = ShopPhoto.sharedInstance.gids[indexPath.section]
            header.title.text = ShopPhoto.sharedInstance.names[gid]

            return header
        }

        return UICollectionReusableView()
    }
}
