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

    private static let refSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    static func defaultSize(for character: Character, pronunciation: String) -> NSSize {
        let characterAttrString = NSAttributedString(string: String(character), attributes: characterAttributes)
        let pronunciationAttrString = NSAttributedString(string: pronunciation, attributes: pronunciationAttributes)
        return CharacterWithPronunciationView.defaultSize(forCharacter: characterAttrString, pronunciation: pronunciationAttrString)
    }

    static let defaultHeight: CGFloat = CharacterWithPronunciationView.defaultHeight

    override func loadView() {
        self.view = CharacterWithPronunciationView()
    }

    func configure(character: Character, pronunciation: String) {
        guard let view = self.view as? CharacterWithPronunciationView else { return }
        view.pronunciationAttrString = NSAttributedString(string: pronunciation, attributes: pronunciationAttributes)
        view.characterAttrString = NSAttributedString(string: String(character), attributes: characterAttributes)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        guard let view = self.view as? CharacterWithPronunciationView else { return }
        view.pronunciationAttrString = nil
        view.characterAttrString = nil
    }
}


private let kDrawingOptions: NSString.DrawingOptions = [.usesLineFragmentOrigin]
private class CharacterWithPronunciationView: NSView {

    private static let refSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    static func defaultSize(forCharacter character: NSAttributedString, pronunciation: NSAttributedString) -> NSSize {
        let characterSize = character.boundingRect(with: refSize, options: kDrawingOptions)
        let pronunciationSize = pronunciation.boundingRect(with: refSize, options: kDrawingOptions)

        let width = max(characterSize.width, pronunciationSize.width)
        return NSSize(width: width, height: defaultHeight)
    }

    static let defaultHeight = kPronunciationHeight + kSpacing + kCharacterHeight

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }

    func setup() {
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .duringViewResize
        self.canDrawConcurrently = true
    }

    var pronunciationAttrString: NSAttributedString? {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    var characterAttrString: NSAttributedString? {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        let pronunciationFrame = NSRect(x: 0, y: self.bounds.height - kPronunciationHeight, width: self.bounds.width, height: kPronunciationHeight)
        let characterFrame = NSRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - kPronunciationHeight - kSpacing)

        if let pronunciationAttrString = pronunciationAttrString, pronunciationFrame.intersects(dirtyRect) {
            pronunciationAttrString.draw(with: pronunciationFrame, options: kDrawingOptions)
        }

        if let characterAttrString = characterAttrString, characterFrame.intersects(dirtyRect) {
            characterAttrString.draw(with: characterFrame, options: kDrawingOptions)
        }
    }
}


private let pronunciationAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 12, weight: .light),
    .foregroundColor: NSColor.controlTextColor,
    .paragraphStyle: { () -> NSParagraphStyle in
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = kPronunciationHeight
        style.minimumLineHeight = kPronunciationHeight
        style.alignment = .center
        return style
    }()
]

private let characterAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont(name: "Kaiti TC", size: 32) ?? NSFont(name: "Songti TC", size: 32) ?? NSFont.systemFont(ofSize: 32),
    .foregroundColor: NSColor.controlTextColor,
    .paragraphStyle: { () -> NSParagraphStyle in
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = kCharacterHeight
        style.minimumLineHeight = kCharacterHeight
        style.alignment = .center
        return style
    }()
]
