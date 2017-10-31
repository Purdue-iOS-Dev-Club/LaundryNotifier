//
//  LaundryWasherDryerViewController.swift
//  Purdue
//
//  Created by George Lo on 11/20/15.
//  Copyright © 2015 Purdue iOS Dev Club. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LaundryWasherDryerCell"
private let margin = CGFloat(10)

class LaundryWasherDryerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var type = ""
    var machines = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() != .pad {
            return CGSize(width: (ScreenWidth - margin * 3) / 2, height: (ScreenWidth - margin * 3) / 2 + 40)
        } else {
            return CGSize(width: (ScreenWidth - margin * 4) / 3, height: (ScreenWidth - margin * 4) / 3 + 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.machines.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LaundryWasherDryerCell
        
        cell.titleLabel.text = self.machines[(indexPath as NSIndexPath).row]["name"] as? String
        cell.imageView.image = UIImage(named: type)
        cell.statusLabel.text = self.machines[(indexPath as NSIndexPath).row]["status"] as? String
        if cell.statusLabel.text == "Available" {
            cell.statusLabel.textColor = UIColor(red: 0.086, green: 0.627, blue: 0.522, alpha: 1)
        } else if cell.statusLabel.text == "In use" {
            cell.statusLabel.textColor = UIColor.red
        } else if cell.statusLabel.text == "End of cycle" {
            cell.statusLabel.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
        } else if cell.statusLabel.text == "Almost done" {
            cell.statusLabel.textColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1)
        } else if cell.statusLabel.text == "Ready to start" || cell.statusLabel.text == "Payment in progress" {
            cell.statusLabel.textColor = UIColor(red: 0.902, green: 0.494, blue: 0.133, alpha: 1)
        } else if cell.statusLabel.text == "Not online" {
            cell.statusLabel.textColor = UIColor(red: 0.204, green: 0.596, blue: 0.859, alpha: 1)
        } else {
            cell.statusLabel.textColor = UIColor.black
        }
        if self.machines[(indexPath as NSIndexPath).row]["time"] == nil {
            cell.timeLabel.text = nil
        } else {
            let time = self.machines[(indexPath as NSIndexPath).row]["time"] as! String
            cell.timeLabel.text = "\(time) min left"
        }
    
        return cell
    }

}
