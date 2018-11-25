//
//  TrackingSelectionView.swift
//  JyutPing
//
//  Created by Cat Jia on 25/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

class TrackingSelectionView: NSImageView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }

    func setup() {
        let selectionImage = NSImage(named: "CharacterSelection")
        selectionImage?.resizingMode = .stretch
        selectionImage?.capInsets = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        assert(selectionImage != nil, "selectionImage is not found")
        self.image = selectionImage
        self.imageScaling = .scaleAxesIndependently
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
}
