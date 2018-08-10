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

    private(set) var referenceCoordinates: (Int, Int) = (0, 0)
    private(set) var tileSize: CGFloat = 100.0
    private(set) var centreCoordinates: (Int, Int) = (Int.max, Int.max)

    private(set) var observingScrollview: Bool = false

    private var allocatedTiles: [GridTile] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        defineScrollableArea()
        centreOurReferenceView()
        allocateInitialTiles()
        observeScrollview()
    }

    deinit {
        if observingScrollview {
            hostScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
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

    private func allocateInitialTiles() {
        if let scrollview = hostScrollView {
            adjustGrid(for: scrollview)
        }
    }

    private func populateGridInBounds(lowerX: Int, upperX: Int, lowerY: Int, upperY: Int) {
        guard upperX > lowerX, upperY > lowerY else { return }
        var coordX = lowerX
        while coordX <= upperX {
            var coordY = lowerY
            while coordY <= upperY {
                allocateTile(at: (coordX, coordY))
                coordY += 1
            }
            coordX += 1
        }
    }

    private func tileExists(at tileCoordinates: (Int, Int)) -> Bool {
        for tile in allocatedTiles where tile.coordinates == tileCoordinates {
            return true
        }
        return false
    }

    private func allocateTile(at tileCoordinates: (Int, Int)) {
        guard tileExists(at: tileCoordinates) == false else { return }
        let tile = GridTile(frame: frameForTile(at: tileCoordinates), coordinates: tileCoordinates)
        allocatedTiles.append(tile)
        self.addSubview(tile)
        print("We allocated a new tile at \(tileCoordinates)")
    }

    private func frameForTile(at coordinates: (Int, Int)) -> CGRect {
        let xIntOffset = coordinates.0 - referenceCoordinates.0
        let yIntOffset = coordinates.1 - referenceCoordinates.1
        let xOffset = self.bounds.size.width * 0.5 + (tileSize * (CGFloat(xIntOffset) - 0.5))
        let yOffset = self.bounds.size.height * 0.5 + (tileSize * (CGFloat(yIntOffset) - 0.5))
        return CGRect(x: xOffset, y: yOffset, width: tileSize, height: tileSize)
    }

    private func observeScrollview() {
        guard observingScrollview == false,
            let scrollview = hostScrollView
            else { return }
        scrollview.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        observingScrollview = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollview = object as? UIScrollView else { return }
        adjustGrid(for: scrollview)
    }

    private func adjustGrid(for scrollview: UIScrollView) {
        let centre = computedCentreCoordinates(scrollview)
        guard centre != centreCoordinates else { return }
        self.centreCoordinates = centre
        print("centre is now at coordinates: \(centre)")
        let centreX = centre.0
        let centreY = centre.1
        let xTilesRequired = Int(UIScreen.main.bounds.size.width / tileSize)
        let yTilesRequired = Int(UIScreen.main.bounds.size.height / tileSize)
        populateGridInBounds(lowerX: centreX - xTilesRequired, upperX: centreX + xTilesRequired,
                             lowerY: centreY - yTilesRequired, upperY: centreY + yTilesRequired)
    }

    private func computedCentreCoordinates(_ scrollview: UIScrollView) -> (Int, Int) {
        guard tileSize > 0 else { return centreCoordinates }
        let contentOffset = scrollview.contentOffset
        let scrollviewSize = scrollview.frame.size
        let xOffset = -(self.center.x - (contentOffset.x + scrollviewSize.width * 0.5))
        let yOffset = -(self.center.y - (contentOffset.y + scrollviewSize.height * 0.5))
        let xIntOffset = Int((xOffset / tileSize).rounded())
        let yIntOffset = Int((yOffset / tileSize).rounded())
        return (xIntOffset + referenceCoordinates.0, yIntOffset + referenceCoordinates.1)
    }

}
