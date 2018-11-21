//
//  MainViewController+WebView.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import WebKit

private class WebViewHandler: Namespace {
    static let speakCharacter = "SpeakCharacter"
}

private class WebViewFormatter {
    private init() {}
    static func singleLookupResult(characterString: String, pronunciation: String) -> [String: String] {
        return ["character": characterString, "pronunciation": pronunciation]
    }
}

private var kJyutDictKey = ""
extension MainViewController {
    private typealias JyutDict = NSDictionary // [String: [String: Int]]; NSDictionary is much faster for lookup
    private typealias JyutDictValue = [String: Int]
    private var jyutDict: JyutDict? {
        set { objc_setAssociatedObject(self, &kJyutDictKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &kJyutDictKey) as? JyutDict }
    }


    func initializeWebView() {
        // load JyutDict
        if let url = Bundle.main.url(forResource: "JyutDict", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JyutDict {
            self.jyutDict = dict
        } else {
            assertionFailure("unexpected when loading JyutDict")
        }

        // setup js handler
        let userContentController = webView.configuration.userContentController
        let scriptMessageProxy = ScriptMessageProxy(for: self)
        userContentController.add(scriptMessageProxy, name: WebViewHandler.speakCharacter) // add a proxy, not `self` to avoid retain cycle `self - webView - self`

        // load WebView content
        if let webviewBundleURL = Bundle.main.url(forResource: "JyutPing", withExtension: "bundle"),
            let webviewBundle = Bundle(url: webviewBundleURL),
            let url = webviewBundle.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: webviewBundleURL)
            webView.navigationDelegate = self
        } else {
            assertionFailure("unexpected when loading WebView")
        }
    }


    /// call `setWebViewContent(textToLookup:)` instead
    func setWebViewContent(textToLookup: String) {
        var textToLookup = textToLookup
        if self.autoConvertsSimplifiedChinese {
            textToLookup = textToLookup.applyingTransform(StringTransform(rawValue: "Hans-Hant"), reverse: false) ?? textToLookup
        }

        let array: [[String: String]] = textToLookup.map { (character) in
            let stringChar = String(character)
            let pronunciationDict = jyutDict?[stringChar] as? JyutDictValue
            let sorted = pronunciationDict?.sorted { $0.value > $1.value }.map { $0.key }

            let pronunciation: String?
            if self.displaysMostlyUsedPronunciationOnly {
                pronunciation = sorted?.first
            } else {
                pronunciation = sorted?.joined(separator: ", ")
            }
            
            return WebViewFormatter.singleLookupResult(characterString: stringChar, pronunciation: pronunciation ?? "")
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                assertionFailure("unexpected")
                return
        }

        webView.evaluateJavaScript("displayLookupResult(\(jsonString))", completionHandler: nil)
    }
}


extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.displayText("你好")
    }
}


extension MainViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case WebViewHandler.speakCharacter:
            guard let string = message.body as? String, !string.isEmpty else { return }
            self.startSpeaking(text: string)

        default:
            break
        }
    }
}


private class ScriptMessageProxy: NSObject, WKScriptMessageHandler {
    private weak var weakRealHandler: WKScriptMessageHandler?
    init(for weakRealHandler: WKScriptMessageHandler?) {
        self.weakRealHandler = weakRealHandler
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        weakRealHandler?.userContentController(userContentController, didReceive: message)
    }
}
