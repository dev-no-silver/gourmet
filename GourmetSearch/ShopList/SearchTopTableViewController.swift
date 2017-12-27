//
//  SearchTopTableViewController.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/17.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import UIKit

class SearchTopTableViewController: UITableViewController {
    
    var freeword: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        freeword?.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Freeword") as! FreewordTableViewCell
            self.freeword = cell.freeword
            
            cell.freeword.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }

        return UITableViewCell()
    }
}

extension SearchTopTableViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSegue(withIdentifier: "PushShopList", sender: self)
        
        return true
    }
}

extension SearchTopTableViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushShopList" {
            let vc = segue.destination as! ShopListViewController
            vc.yls.condition.query = freeword?.text
        }
    }
}
