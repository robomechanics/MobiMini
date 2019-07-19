//
//  PeripheralViewController.swift
//  MobiMini
//
//  Created by Edward on 7/15/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: CBControl?

    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleImage: UIImageView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshPeripherals), for: .valueChanged)

        tableView.dataSource = self
        tableView.delegate = self
        
        delegate?.scan()
        tableView.reloadData()
    }
    
    @objc
    func refreshPeripherals(_ sender: Any) {
        delegate?.scan()
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.peripherals.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath) as? PeripheralTableViewCell else {
            fatalError("The dequeued cell is not an instance of PeripheralTableViewCell.")
        }
        cell.peripheralID.text = delegate?.peripherals[indexPath.row].identifier.uuidString
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainPeripheral = delegate?.peripherals[indexPath.row]
        delegate?.robotPeripheral = mainPeripheral
        delegate?.connect()
    }
}
