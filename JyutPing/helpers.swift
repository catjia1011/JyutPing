//
//  helpers.swift
//  JyutPing
//
//  Created by Cat Jia on 4/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

extension NSObject {
    func lazyAssociated<T>(_ key: UnsafeRawPointer, _ policy: objc_AssociationPolicy, generateBlock: () -> T) -> T {
        if let value = objc_getAssociatedObject(self, key) as? T {
            return value
        } else {
            let value = generateBlock()
            objc_setAssociatedObject(self, key, value, policy)
            return value
        }
    }
}

extension NSSpeechSynthesizer {
    static var cantoneseVoice: VoiceName? {
        return self.availableVoices.first { self.attributes(forVoice: $0)[.localeIdentifier] as? String == "zh_HK" }
    }
}
