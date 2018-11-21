//
//  MainViewController.swift
//  JyutPing
//
//  Created by Cat Jia on 4/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa
import WebKit

class MainViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var webViewWrapper: NSView!
    let webView: WKWebView = NoMenuWebView()

    @IBOutlet weak var settingSegmentControl: NSSegmentedControl!
    @IBOutlet weak var settingMenu: NSMenu!

    var autoConvertsSimplifiedChinese = UserDefaults.standard.bool(forKey: UserDefaultsKey.autoConvertsSimplifiedChinese)
    var displaysMostlyUsedPronunciationOnly = UserDefaults.standard.bool(forKey: UserDefaultsKey.displaysMostlyUsedPronunciationOnly)

    override func awakeFromNib() {
        super.awakeFromNib()

        // WKWebView cannot be added using IB when targeting 10.11 and before
        webViewWrapper.addSubview(webView)
        webView.frame = webViewWrapper.bounds
        webView.autoresizingMask = [.width, .height]

        // dropmenu for settingSegmentControl
        settingSegmentControl.setMenu(settingMenu, forSegment: 0)
        if #available(OSX 10.13, *) {
            settingSegmentControl.setShowsMenuIndicator(true, forSegment: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeOutlineView()
        self.initializeWebView()

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private var currrentDisplayedText: String?
    func displayText(_ text: String) {
        self.currrentDisplayedText = text
        self.setWebViewContent(textToLookup: text)
    }

    func reloadDisplayedText() {
        guard let text = self.currrentDisplayedText else { return }
        self.setWebViewContent(textToLookup: text)
    }
    
    @IBAction func speakButtonAction(_ sender: NSButton) {
        guard let currrentText = self.currrentDisplayedText, currrentText != "" else { return }
        self.startSpeaking(text: currrentText)
    }

    @objc private func didReceiveNotification(_ notification: Notification) {
        switch notification.name {
        case UserDefaults.didChangeNotification:
            let newAutoConvertsSimplifiedChinese = UserDefaults.standard.bool(forKey: UserDefaultsKey.autoConvertsSimplifiedChinese)
            let newDisplaysMostlyUsedPronunciationOnly = UserDefaults.standard.bool(forKey: UserDefaultsKey.displaysMostlyUsedPronunciationOnly)

            var changed = false
            changed = changed || (newAutoConvertsSimplifiedChinese != autoConvertsSimplifiedChinese)
            changed = changed || (newDisplaysMostlyUsedPronunciationOnly != displaysMostlyUsedPronunciationOnly)

            autoConvertsSimplifiedChinese = newAutoConvertsSimplifiedChinese
            displaysMostlyUsedPronunciationOnly = newDisplaysMostlyUsedPronunciationOnly
            
            if changed {
                self.reloadDisplayedText()
            }

        default:
            break
        }
    }
}


private class NoMenuWebView: WKWebView {
    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        super.willOpenMenu(menu, with: event)
        menu.cancelTracking()
    }
}

