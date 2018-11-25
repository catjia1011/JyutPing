//
//  PaperLineView.swift
//  JyutPing
//
//  Created by Cat Jia on 24/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

private let kMinimalLineInterval = 10 as CGFloat
private let kDashLineColor = NSColor.black.withAlphaComponent(0.24)

class PaperLineView: NSView {
    var lineInterval: CGFloat = 32 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }

    func setup() {
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .beforeViewResize
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        guard lineInterval >= kMinimalLineInterval else { return }

        // reverse context
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -self.bounds.height)

        // reverse dirtyRect
        var dirtyRect = dirtyRect
        dirtyRect.origin.y = self.bounds.height - dirtyRect.maxY

        // draw horizontal lines
        ctx.setStrokeColor(kDashLineColor.cgColor)
        ctx.setLineWidth(1)
        ctx.setLineDash(phase: 0, lengths: [1, 1])

        var y = ceil(dirtyRect.origin.y / lineInterval) * lineInterval
        while y <= dirtyRect.maxY {
            if y > 0 { // y > 0: do not draw the first line
                ctx.addLines(between: [CGPoint(x: 0, y: y), CGPoint(x: self.bounds.width, y: y)])
            }
            y += lineInterval
        }
        ctx.strokePath()
    }
}
