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
    private var speechSynthesizer: NSSpeechSynthesizer {
        return lazyAssociated(&kSpeechSynthesizerKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
            let synthesizer = NSSpeechSynthesizer()
            synthesizer.delegate = self
            return synthesizer
        }
    }

    var isSpeaking: Bool {
        return self.speechSynthesizer.isSpeaking
    }

    func startSpeaking(text: String) {
        guard let cantoneseVoice = NSSpeechSynthesizer.cantoneseVoice else {
            let alert = NSAlert()
            alert.messageText = "Cantonese speech package is not available. Please go to System Preferences to download and install it."
            alert.runModal()
            return
        }

        if self.speechSynthesizer.voice() != cantoneseVoice {
            self.speechSynthesizer.setVoice(cantoneseVoice)
        }

        self.speechSynthesizer.startSpeaking(text)
        self.speakButton.state = .on
    }

    func stopSpeaking() {
        self.speechSynthesizer.stopSpeaking()
    }
}


extension MainViewController: NSSpeechSynthesizerDelegate {
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        self.speakButton.state = .off
    }
}
