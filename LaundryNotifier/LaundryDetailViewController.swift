//
//  LaundryDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 11/19/15.
//  Copyright © 2015 Purdue iOS Dev Club. All rights reserved.
//

import UIKit

class LaundryDetailViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    var washers = [NSDictionary]()
    var dryers = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.hideBottomHairline()
        
        let navigation = CarbonTabSwipeNavigation(items: ["Washers", "Dryers"], rootViewController: self)
        navigation.setIndicatorColor(self.navigationController?.navigationBar.tintColor)
        navigation.setIndicatorHeight(2)
        navigation.setNormalColor(self.navigationController!.navigationBar.tintColor)
        navigation.setSelectedColor(self.navigationController!.navigationBar.tintColor)
        navigation.setTabExtraWidth(10)
        navigation.carbonSegmentedControl?.backgroundColor = UIColor.clear
        navigation.toolbar.barTintColor = self.navigationController!.navigationBar.barTintColor!
        navigation.toolbar.isTranslucent = false
        navigation.delegate = self
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index: UInt) -> LaundryWasherDryerViewController {
        let laundryWDVC = self.storyboard?.instantiateViewController(withIdentifier: "LaundryWasherDryerViewController") as! LaundryWasherDryerViewController
        laundryWDVC.type = index % 2 == 0 ? "Washer" : "Dryer"
        laundryWDVC.machines = index % 2 == 0 ? self.washers : self.dryers
        return laundryWDVC
    }

}
