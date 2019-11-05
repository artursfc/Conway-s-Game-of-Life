//
//  TabBarViewController.swift
//  Conway's-Game-of-Life
//
//  Created by Artur Carneiro on 01/11/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bronzeViewController = BronzeViewController()
        bronzeViewController.tabBarItem = UITabBarItem(title: "Bronze", image: nil, tag: 0)
        
        let silverViewController = SilverViewController()
        silverViewController.tabBarItem = UITabBarItem(title: "Silver", image: nil, tag: 1)
        
        
        self.viewControllers = [bronzeViewController, silverViewController]
    }
}
