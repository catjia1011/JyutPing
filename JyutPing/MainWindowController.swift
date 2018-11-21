//
//  MainWindowController.swift
//  JyutPing
//
//  Created by Cat Jia on 4/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var lookupButton: NSButton!

    var contentController: MainViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentController = self.contentViewController as? MainViewController
    }

    func lookup(text: String) {
        self.contentController.addLookupHistory(text: text)
        self.contentController.displayText(text)
    }

    @IBAction func didTapLookupButton(_ sender: Any) {
        self.lookup(text: searchField.stringValue)
    }

    @IBAction func searchFieldDidReturn(_ sender: Any) {
        self.lookup(text: searchField.stringValue)
    }
}
