//
//  DoubleLineView.swift
//  JyutPing
//
//  Created by Cat Jia on 25/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

class DoubleLineView: NSView {

    static let defaultWidth: CGFloat = 20

    let lineColor: NSColor = {
        let fallbackColor = NSColor(red:0.54, green:0.22, blue:0.40, alpha:1.0).withAlphaComponent(0.5)
        if #available(OSX 10.13, *) {
            let namedLineColor = NSColor(named: "DoubleLineColor")
            assert(namedLineColor != nil)
            return namedLineColor ?? fallbackColor
        } else {
            return fallbackColor
        }
    }()

    var isUserInterfaceEnabled: Bool = true

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
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    override func setFrameSize(_ newSize: NSSize) {
        let widthChanged = (newSize.width != self.frame.size.width)
        super.setFrameSize(newSize)
        if widthChanged {
            self.needsDisplay = true
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        ctx.setLineWidth(1)
        ctx.setStrokeColor(lineColor.cgColor)
        for x: CGFloat in [15, 18] {
            ctx.addLines(between: [CGPoint(x: x, y: dirtyRect.minY), CGPoint(x: x, y: dirtyRect.maxY)])
        }
        ctx.strokePath()
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return isUserInterfaceEnabled ? super.hitTest(point) : nil
    }
}
