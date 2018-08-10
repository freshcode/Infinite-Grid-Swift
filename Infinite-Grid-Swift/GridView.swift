//
//  GridView.swift
//  Infinite-Grid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-10.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit
class GridView: UIView {
    @IBOutlet weak var hostScrollView: UIScrollView?
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var leftConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightConstraint: NSLayoutConstraint?

    // arbitraryLargeOffset defines how much user can scroll before hitting the
    // edges of the scrollview and bounce/stop
    private let arbitraryLargeOffset: CGFloat = 10000000.0

    override func awakeFromNib() {
        super.awakeFromNib()
        defineScrollableArea()
        centreOurReferenceView()
    }

    private func defineScrollableArea() {
        guard let scrollview = hostScrollView else { return }
        topConstraint?.constant = arbitraryLargeOffset
        bottomConstraint?.constant = arbitraryLargeOffset
        leftConstraint?.constant = arbitraryLargeOffset
        rightConstraint?.constant = arbitraryLargeOffset
        scrollview.layoutIfNeeded()
    }

    private func centreOurReferenceView()
    {
        guard let scrollview = hostScrollView else { return }
        let xOffset = arbitraryLargeOffset - ((scrollview.frame.size.width - self.frame.size.width) * 0.5)
        let yOffset = arbitraryLargeOffset - ((scrollview.frame.size.height - self.frame.size.height) * 0.5)
        scrollview.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: false)
    }
}
