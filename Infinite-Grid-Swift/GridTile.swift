//
//  GridTile.swift
//  Infinite-Grid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-10.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit

class GridTile: UIView {

    let coordinates: (Int, Int)

    init(frame: CGRect, coordinates: (Int, Int)) {
        self.coordinates = coordinates
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.addCoordinatesLabel()
    }

    private func addCoordinatesLabel() {
        let label = UILabel(frame: self.bounds)
        label.text = "\(coordinates)"
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
    }

    // Unused, not supporting Xib/Storyboard
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
