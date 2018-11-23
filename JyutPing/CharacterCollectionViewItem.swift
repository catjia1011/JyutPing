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
    private let pronunciationField = generateLabelField()
    private let characterField = generateLabelField()

    private static let refTextField = generateLabelField() // NSTextField needs bigger space to show text completely than `NSAttributedString.boundingRect(with:options:)` returns
    private static let refSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    static func defaultSize(for character: Character, pronunciation: String) -> NSSize {
        refTextField.attributedStringValue = NSAttributedString(string: String(character), attributes: characterAttributes)
        let characterSize = refTextField.sizeThatFits(refSize)

        refTextField.attributedStringValue = NSAttributedString(string: pronunciation, attributes: pronunciationAttributes)
        let pronunciationSize = refTextField.sizeThatFits(refSize)

        let width = max(characterSize.width, pronunciationSize.width)
        return NSSize(width: width, height: (kPronunciationHeight + kSpacing + kCharacterHeight))
    }

    override func loadView() {
        self.view = NSView()

        self.view.addSubview(pronunciationField)
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


private func generateLabelField() -> NSTextField {
    let field = NSTextField()
    field.isBezeled = false
    field.isEditable = false
    field.drawsBackground = false
    field.usesSingleLineMode = false
    return field
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
