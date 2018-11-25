//
//  OutlineHeaderCellView.swift
//  JyutPing
//
//  Created by Cat Jia on 19/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

protocol OutlineHeaderCellViewDelegate: NSObjectProtocol {
    func outlineHeaderCellView(_ cellView: OutlineHeaderCellView, didTapClearButton clearButton: NSButton) -> Void
}

class OutlineHeaderCellView: NSTableCellView {

    @IBOutlet weak var clearButton: NSButton!

    weak var delegate: OutlineHeaderCellViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        clearButton.isHidden = true
    }

    @IBAction func didTapClearButton(_ sender: NSButton) {
        self.delegate?.outlineHeaderCellView(self, didTapClearButton: sender)
    }

    private weak var trackingArea: NSTrackingArea?
    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea = self.trackingArea, self.trackingAreas.contains(trackingArea) {
            self.removeTrackingArea(trackingArea)
        }

        let trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        self.trackingArea = trackingArea
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        clearButton.isHidden = false
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        clearButton.isHidden = true
    }
}
