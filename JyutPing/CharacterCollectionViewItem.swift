//
//  CharacterCollectionViewItem.swift
//  JyutPing
//
//  Created by Cat Jia on 22/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

private let kPronunciationHeight: CGFloat = 16
private let kCharacterHeight: CGFloat = 34
private let kSpacing: CGFloat = 6

class CharacterCollectionViewItem: NSCollectionViewItem {
    private let pronunciationField = NSTextField()
    private let characterField = NSTextField()

    private static let refSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    private static let sizingOptions: NSString.DrawingOptions = [.usesFontLeading]
    static func defaultSize(for character: Character, pronunciation: String) -> NSSize {
        let characterSize = NSAttributedString(string: String(character), attributes: characterAttributes).boundingRect(with: refSize, options: sizingOptions)
        let pronunciationSize = NSAttributedString(string: pronunciation, attributes: pronunciationAttributes).boundingRect(with: refSize, options: sizingOptions)
        let width = max(characterSize.width, pronunciationSize.width)
        return NSSize(width: width, height: (kPronunciationHeight + kSpacing + kCharacterHeight))
    }

    override func loadView() {
        self.view = NSView()

        pronunciationField.isBezeled = false
        pronunciationField.isEditable = false
        pronunciationField.drawsBackground = false
        pronunciationField.usesSingleLineMode = false
        self.view.addSubview(pronunciationField)

        characterField.isBezeled = false
        characterField.isEditable = false
        characterField.drawsBackground = false
        characterField.usesSingleLineMode = false
        self.view.addSubview(characterField)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        characterField.frame = NSRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - kPronunciationHeight - kSpacing)
        pronunciationField.frame = NSRect(x: 0, y: self.view.bounds.height - kPronunciationHeight, width: self.view.bounds.width, height: kPronunciationHeight)
    }

    func configure(character: Character, pronunciation: String) {
        characterField.attributedStringValue = NSAttributedString(string: String(character), attributes: characterAttributes)
        pronunciationField.attributedStringValue = NSAttributedString(string: pronunciation, attributes: pronunciationAttributes)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterField.stringValue = ""
        pronunciationField.stringValue = ""
    }
}


private let pronunciationAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 12),
    .paragraphStyle: { () -> NSParagraphStyle in
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = kPronunciationHeight
        style.minimumLineHeight = kPronunciationHeight
        style.alignment = .center
        return style
    }()
]

private let characterAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont(name: "Kaiti TC", size: 32) ?? NSFont.systemFont(ofSize: 32),
    .paragraphStyle: { () -> NSParagraphStyle in
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = kCharacterHeight
        style.minimumLineHeight = kCharacterHeight
        style.alignment = .center
        return style
    }()
]
