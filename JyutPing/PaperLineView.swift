//
//  PaperLineView.swift
//  JyutPing
//
//  Created by Cat Jia on 24/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

private let kMinimalLineInterval = 10 as CGFloat
private let kPinkLineColor = NSColor(red:0.54, green:0.22, blue:0.40, alpha:1.0).withAlphaComponent(0.5)
private let kDashLineColor = NSColor.black.withAlphaComponent(0.24)

class PaperLineView: NSView {
    var lineInterval: CGFloat = 32 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }

    override var isOpaque: Bool {
        return false
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        // clear background
        ctx.setFillColor(NSColor.clear.cgColor)
        ctx.fill(self.bounds)

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

        // draw vertical lines
        ctx.setStrokeColor(kPinkLineColor.cgColor)
        ctx.setLineDash(phase: 0, lengths: [])
        for x: CGFloat in [15, 18] {
            ctx.addLines(between: [CGPoint(x: x, y: dirtyRect.minY), CGPoint(x: x, y: dirtyRect.maxY)])
        }
        ctx.strokePath()
    }
}
