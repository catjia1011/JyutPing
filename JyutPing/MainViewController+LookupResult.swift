//
//  MainViewController+LookupResult.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

private var kJyutDictKey = ""
extension MainViewController {
    private typealias JyutDict = NSDictionary // [String: [String: Int]]; NSDictionary is much faster for lookup
    private typealias JyutDictValue = [String: Int]

    /// open data `JyutDict.json` is from https://words.hk/faiman/analysis/existingcharpronunciations
    private var jyutDict: JyutDict? {
        return lazyAssociated(&kJyutDictKey, .OBJC_ASSOCIATION_COPY_NONATOMIC) {
            if let url = Bundle.main.url(forResource: "JyutDict", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JyutDict {
                return dict
            } else {
                assertionFailure("unexpected when loading JyutDict")
                return nil
            }
        }
    }


    private static let avoidedCharacterSet
        = CharacterSet(charactersIn: "a"..."z")
            .union(CharacterSet(charactersIn: "A"..."Z"))
            .union(CharacterSet(charactersIn: "0"..."9"))

    /// call `displayText(_:)` instead
    func showLookupResult(of text: String) {
        var text = text
        if self.autoConvertsSimplifiedChinese {
            text = text.applyingTransform(StringTransform(rawValue: "Hans-Hant"), reverse: false) ?? text
        }

        let results: [SingleLookupResult] = text.map { (character) in
            // the dict also contains numbers and letters
            // if char is number or letter, skip searching the dict
            if let unicodeScalar = character.unicodeScalars.first, type(of: self).avoidedCharacterSet.contains(unicodeScalar) {
                return SingleLookupResult(character: character, pronunciation: "")
            }

            let pronunciationDict = jyutDict?[String(character)] as? JyutDictValue
            let sorted = pronunciationDict?.sorted { $0.value > $1.value }.map { $0.key }

            let pronunciation: String?
            if self.displaysMostlyUsedPronunciationOnly {
                pronunciation = sorted?.first
            } else {
                pronunciation = sorted?.joined(separator: ", ")
            }
            
            return SingleLookupResult(character: character, pronunciation: pronunciation ?? "")
        }

        self.lookupResultVC.results = results
    }
}


//extension MainViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.displayText("你好")
//    }
//}
//
//
//extension MainViewController: WKScriptMessageHandler {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        switch message.name {
//        case WebViewHandler.speakCharacter:
//            guard let string = message.body as? String, !string.isEmpty else { return }
//            self.startSpeaking(text: string)
//
//        default:
//            break
//        }
//    }
//}
