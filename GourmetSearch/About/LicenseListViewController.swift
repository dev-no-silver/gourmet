//
//  LicenseListViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2018/01/01.
//  Copyright © 2018年 Yasunari Kondo. All rights reserved.
//

import UIKit

class LicenseListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private struct Software {
        var name: String
        var license: String
    }

    private var softwares = [Software]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let path = Bundle.main.path(forResource: "Licenses", ofType: "plist") else { return }
        guard let items = NSArray(contentsOfFile: path) else { return }

        for item in items {
            guard let software = item as? NSDictionary else { continue }

            guard let name = software["Name"] as? String else { continue }
            guard let license = software["License"] as? String else { continue }

            self.softwares.append(Software(name: name, license: license))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LicenseListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Software", for: indexPath)
        cell.textLabel?.text = self.softwares[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.softwares.count
    }
}
