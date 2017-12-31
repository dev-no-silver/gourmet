//
//  ShopDetailViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/24.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var photoListContainer: UIView!

    var shop = Shop()

    let ipc = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()

        self.ipc.delegate = self
        self.ipc.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.delegate = self
        self.setup()
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.scrollView.delegate = nil
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        let nameFrame = name.sizeThatFits(CGSize(width: name.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        nameHeight.constant = nameFrame.height
        
        let addressFrame = address.sizeThatFits(CGSize(width: address.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        addressContainerHeight.constant = addressFrame.height
        view.layoutIfNeeded()
    }
    
    func updateFavoriteButton() {
        guard let gid = shop.gid else { return }
        
        if Favorite.inFavorites(gid) {
            favoriteIcon.image = UIImage(named: "star-on")
            favoriteLabel.text = "お気に入りからはずす"
        } else {
            favoriteIcon.image = UIImage(named: "star-off")
            favoriteLabel.text = "お気に入りに入れる"
        }
    }
    
    fileprivate func configure() {
        if let url = shop.photoUrl {
            photo.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "loading"))
        } else {
            photo.image = UIImage(named: "loading")
        }
        
        name.text = shop.name
        tel.text = shop.tel
        address.text = shop.address
        
        self.setupMapKit()

        updateFavoriteButton()
    }

    fileprivate func setup() {
        self.photoListContainer.isHidden =  !ShopPhoto.sharedInstance.hasPhotos(shop.gid!)
    }
    
    fileprivate func setupMapKit() {
        guard let lat = shop.lat,
            let lon = shop.lon
            else { return }
        
        let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 200, 200)
        
        map.setRegion(mkcr, animated: false)
        
        let pin = MKPointAnnotation()
        pin.coordinate = cllc
        map.addAnnotation(pin)
    }
    
    // MARK: - IBAction
    @IBAction func telTapped(_ sender: UIButton) {
        guard let tel = shop.tel else { return }
        guard let url = URL(string: "tel:\(tel)") else { return }

        if !UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: "電話をかけることができません", message: "この端末には電話機能が搭載されていません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        guard let name = shop.name else { return }
        let alert = UIAlertController(title: "電話", message: "\(name)に電話をかけます", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "電話をかける", style: .destructive, handler: { action in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            })
        )
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addressTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "PushMapDetail", sender: nil)
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        guard let gid = shop.gid else { return }
        
        Favorite.toggle(gid)
        updateFavoriteButton()
    }
    
    @IBAction func addPhotoTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(
                title: "写真を撮る",
                style: .default,
                handler: { action in
                    self.ipc.sourceType = .camera
                    self.present(self.ipc, animated: true, completion: nil)
            }))
        }

        alert.addAction(UIAlertAction(
            title: "写真を選択",
            style: .default,
            handler: { action in
                self.ipc.sourceType = .photoLibrary
                self.present(self.ipc, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in }))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func photoListTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "PushPhotoListFromShopDetail", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushMapDetail" {
            let vc = segue.destination as! ShopMapDetailViewController
            vc.shop = self.shop
        }
        if segue.identifier == "PushPhotoListFromShopDetail" {
            let vc = segue.destination as! PhotoListViewController
            vc.gid = shop.gid
        }
    }
}

extension ShopDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        if scrollOffset <= 0 {
            photo.frame.origin.y = scrollOffset
            photo.frame.size.height = 200 - scrollOffset
        }
        
    }
}

extension ShopDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ipc.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            ShopPhoto.sharedInstance.append(shop: shop, image: image)
        }

        ipc.dismiss(animated: true, completion: nil)
    }

}
