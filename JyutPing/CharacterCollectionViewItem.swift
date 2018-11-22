//
//  CharacterCollectionViewItem.swift
//  JyutPing
//
//  Created by Cat Jia on 22/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

class CharacterCollectionViewItem: NSCollectionViewItem {
    static let defaultHeight: CGFloat = 16/*pronunciation*/ + 6/*spacing*/ + 34/*character*/ // TODO

    static let pronunciationFont = NSFont.systemFont(ofSize: 12)
    static let characterFont = NSFont(name: "Kaiti TC", size: 32) ?? NSFont.systemFont(ofSize: 32)

    private let stackView = NSStackView()
    private let pronunciationField = NSTextField()
    private let characterField = NSTextField()

    static func defaultSize(for characterString: String, pronunciation: String) -> NSSize {
        let characterAttrString = NSAttributedString(string: characterString, attributes: [.font: characterFont])
        let pronunciationAttrString = NSAttributedString(string: pronunciation, attributes: [.font: pronunciationFont])
        let width = [characterAttrString, pronunciationAttrString].map { $0.boundingRect(with: NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude), options: .usesFontLeading).width }.max()!
        return NSSize(width: width, height: defaultHeight)
    }

    override func loadView() {
        self.view = NSView()

        stackView.orientation = .vertical
        stackView.alignment = .centerX
        self.view.addSubview(stackView)

        pronunciationField.font = type(of: self).pronunciationFont
        pronunciationField.alignment = .center
        stackView.addArrangedSubview(pronunciationField)
        pronunciationField.heightAnchor.constraint(equalToConstant: 16).isActive = true

        characterField.font = type(of: self).characterFont
        characterField.alignment = .center
        stackView.addArrangedSubview(characterField)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        stackView.frame = view.bounds
    }

    func configure(character: Character, pronunciation: String) {
        characterField.stringValue = String(character)
        pronunciationField.stringValue = pronunciation
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterField.stringValue = ""
        pronunciationField.stringValue = ""
    }
}
