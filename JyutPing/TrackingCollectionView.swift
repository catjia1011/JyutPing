//
//  TrackingCollectionView.swift
//  JyutPing
//
//  Created by Cat Jia on 23/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

protocol TrackingCollectionViewTrackingDelegate: NSObjectProtocol {
    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseEnteredWith event: NSEvent) -> Void
    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseExitedWith event: NSEvent) -> Void
    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseMovedWith event: NSEvent) -> Void
    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseDraggedWith event: NSEvent) -> Void
}

class TrackingCollectionView: NSCollectionView {

    weak var trackingDelegate: TrackingCollectionViewTrackingDelegate?

    private weak var trackingArea: NSTrackingArea?
    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea = self.trackingArea, self.trackingAreas.contains(trackingArea) {
            self.removeTrackingArea(trackingArea)
        }

        let trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        self.trackingArea = trackingArea
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.trackingDelegate?.trackingCollectionView(self, mouseEnteredWith: event)
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.trackingDelegate?.trackingCollectionView(self, mouseExitedWith: event)
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        self.trackingDelegate?.trackingCollectionView(self, mouseMovedWith: event)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        self.trackingDelegate?.trackingCollectionView(self, mouseDraggedWith: event)
    }
}
