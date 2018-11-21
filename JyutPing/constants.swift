//
//  constants.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

class Namespace {
    private init() {}
}

class UserDefaultsKey: Namespace {
    static let lookupHistory = "LookupHistory"
    static let autoConvertsSimplifiedChinese = "AutoConvertsSimplifiedChinese"
    static let displaysMostlyUsedPronunciationOnly = "DisplaysMostlyUsedPronunciationOnly"
}
