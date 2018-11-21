//
//  NoClippingView.swift
//  JyutPing
//
//  Created by Cat Jia on 21/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

class NoClippingView: NSView {
    private class NoClippingLayer: CALayer {
        override var masksToBounds: Bool {
            set {} get { return false }
        }
    }

    override var wantsDefaultClipping: Bool {
        return false
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }

    private func setup() {
        self.wantsLayer = true
        self.layer = NoClippingLayer()
    }
}
