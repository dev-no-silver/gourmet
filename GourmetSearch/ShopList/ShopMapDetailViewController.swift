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
    
    var shop = Shop()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMapKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
