//
//  Constants.swift
//  Conway's-Game-of-Life
//
//  Created by Artur Carneiro on 05/11/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

private let colorArray: [UIColor] = [.systemRed, .systemYellow, .systemBlue, .systemPurple, .systemGreen, .systemOrange, .systemTeal]

public func randomUIColor() -> UIColor {
    return colorArray[Int.random(in: 0..<colorArray.count)]
}
