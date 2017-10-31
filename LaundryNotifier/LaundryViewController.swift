//
//  LaundryViewController.swift
//  Purdue
//
//  Created by Jiayi Kou on 11/2/15.
//  Copyright © 2015 Purdue iOS Dev Club. All rights reserved.
//

import UIKit

class LaundryViewController: UITableViewController {
    
    var isLoading = true
    var selectedRow = 0
    var laundryPlaces = [NSDictionary]()
    var washers = [NSDictionary]()
    var dryers = [NSDictionary]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.showBottomHairline()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Laundry"

        AFHTTPSessionManager().get("\(serverEndPoint)api/v1/laundry", parameters: nil,progress:nil,
            success: ({(operation: URLSessionDataTask, responseObject: Any) in
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    self.laundryPlaces = responseObject as! [NSDictionary]
                    DispatchQueue.main.async(execute: {
                        self.isLoading = false
                        self.tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
                    })
                }
            }),
            failure: ({(operation: URLSessionDataTask?, error: Error) in
                AppDelegate.delegate().showNetworkErrorAlert("Unable to get laundry data", completion: {
                    self.isLoading = false
                })
            })
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading {
            return 1
        }
        return self.laundryPlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isLoading {
            return tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryCell", for: indexPath)

        cell.imageView!.image = UIImage(named: "LaundryRoom")
        cell.textLabel!.text = self.laundryPlaces[(indexPath as NSIndexPath).row]["laundryName"] as? String

        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = (indexPath as NSIndexPath).row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.startAnimating()
        cell?.accessoryView = indicatorView
        let laundryId = self.laundryPlaces[(indexPath as NSIndexPath).row]["laundryId"] as! String
        AFHTTPSessionManager().get("\(serverEndPoint)api/v1/laundry/\(laundryId)", parameters: nil,progress:nil,
            success: ({(operation: URLSessionDataTask, responseObject: Any) in
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    let laundryMachines = responseObject as! [NSDictionary]
                    self.washers.removeAll()
                    self.dryers.removeAll()
                    for laundryMachine in laundryMachines {
                        if laundryMachine["type"] as! String == "Washer" {
                            self.washers.append(laundryMachine)
                        } else {
                            self.dryers.append(laundryMachine)
                        }
                    }
                    self.washers.sort {
                        let name1 = $0["name"] as! String
                        let name2 = $1["name"] as! String
                        return name1.compare(name2) == ComparisonResult.orderedAscending
                    }
                    DispatchQueue.main.async(execute: {
                        cell?.accessoryView = nil
                        cell?.accessoryType = .disclosureIndicator
                        self.performSegue(withIdentifier: "toLaundryDetail", sender: self)
                    })
                }
            }),
            failure: ({(operation: URLSessionDataTask?, error: Error) in
                AppDelegate.delegate().showNetworkErrorAlert("Unable to get laundry data", completion: {
                    cell?.accessoryView = nil
                    cell?.accessoryType = .disclosureIndicator
                })
            })
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLaundryDetail" {
            let detailVC = segue.destination as! LaundryDetailViewController
            detailVC.title = self.laundryPlaces[selectedRow]["laundryName"] as? String
            detailVC.washers = self.washers
            detailVC.dryers = self.dryers
        }
    }

}
