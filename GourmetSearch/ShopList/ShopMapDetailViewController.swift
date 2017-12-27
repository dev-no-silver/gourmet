//
//  ShopMapDetailViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/25.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit
import MapKit

class ShopMapDetailViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var showHereButton: UIBarButtonItem!

    let ls = LocationService()
    let nc = NotificationCenter.default
    var observers = [NSObjectProtocol]()
    var shop = Shop()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapKit()
    }

    override func viewWillAppear(_ animated: Bool) {
        observers.append(
            nc.addObserver(
                forName: .authDenied,
                object: nil,
                queue: nil,
                using: { notification in
                    self.present(self.ls.locationServiceDisabledAlert, animated: true, completion: nil)
                    self.showHereButton.isEnabled = false
            })
        )

        observers.append(
            nc.addObserver(
                forName: .authRestricted,
                object: nil,
                queue: nil,
                using: { notification in
                    self.present(self.ls.locationServiceRestrictedAlert, animated: true, completion: nil)
                    self.showHereButton.isEnabled = false
            })
        )

        observers.append(
            nc.addObserver(
                forName: .didFailLocation,
                object: nil,
                queue: nil,
                using: { notification in
                    self.present(self.ls.locationServiceDidFailAlert, animated: true, completion: nil)
                    self.showHereButton.isEnabled = false
            })
        )

        observers.append(
            nc.addObserver(
                forName: .didUpdateLocation,
                object: nil,
                queue: nil,
                using: { notification in
                    self.showHereButton.isEnabled = true

                    guard let userInfo = notification.userInfo as? [String: CLLocation] else { return }
                    guard let clloc = userInfo["location"] else { return }

                    guard let lat = self.shop.lat, let lon = self.shop.lon else {
                        return
                    }

                    let center = CLLocationCoordinate2D(
                        latitude: (lat + clloc.coordinate.latitude) / 2,
                        longitude: (lon + clloc.coordinate.longitude) / 2
                    )
                    let diff = (
                        lat: abs(clloc.coordinate.latitude - lat),
                        lon: abs(clloc.coordinate.longitude - lon)
                    )

                    let mkcs = MKCoordinateSpanMake(diff.lat * 1.4, diff.lon * 1.4)
                    let mkcr = MKCoordinateRegionMake(center, mkcs)
                    self.map.setRegion(mkcr, animated: true)

                    self.map.showsUserLocation = true
            })
        )

        observers.append(
            nc.addObserver(
                forName: .authorized,
                object: nil,
                queue: nil,
                using: { notification in
                    self.showHereButton.isEnabled = true
            })
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        for observer in observers {
            nc.removeObserver(observer)
        }
        observers = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setupMapKit() {
        guard let lat = shop.lat,
            let lon = shop.lon
            else { return }

        let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 500, 500)
        map.setRegion(mkcr, animated: false)

        let pin = MKPointAnnotation()
        pin.coordinate = cllc
        pin.title = shop.name
        map.addAnnotation(pin)
    }

    // MARK: - IBAction
    @IBAction func showHereButtonTapped(_ sender: UIBarButtonItem) {
        self.ls.startUpdatingLocation()
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
