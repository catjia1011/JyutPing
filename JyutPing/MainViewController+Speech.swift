//
//  MainViewController+Speech.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

private var kSpeechSynthesizerKey = ""
extension MainViewController {
    private var speechSynthesizer: NSSpeechSynthesizer? {
        set { objc_setAssociatedObject(self, &kSpeechSynthesizerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &kSpeechSynthesizerKey) as? NSSpeechSynthesizer }
    }

    func startSpeaking(text: String) {
        guard let cantoneseVoice = NSSpeechSynthesizer.cantoneseVoice else {
            let alert = NSAlert()
            alert.messageText = "Cantonese speech package is not available. Please go to System Preferences to download and install it."
            alert.runModal()
            return
        }

        let synthesizer: NSSpeechSynthesizer
        if let speechSynthesizer = self.speechSynthesizer {
            synthesizer = speechSynthesizer
        } else {
            synthesizer = NSSpeechSynthesizer()
            synthesizer.setVoice(cantoneseVoice)
            self.speechSynthesizer = synthesizer
        }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking()
        } else {
            synthesizer.startSpeaking(text)
        }
    }
}
