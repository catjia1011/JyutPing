//
//  LookupResultViewController.swift
//  JyutPing
//
//  Created by Cat Jia on 23/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

struct SingleLookupResult {
    let character: Character
    let pronunciation: String
}

class LookupResultViewController: NSViewController {

    private let flowLayout = NSCollectionViewFlowLayout()
    private let collectionView = TrackingCollectionView()
    private let selectionView = NSImageView()

    var results: [SingleLookupResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func loadView() {
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = NSEdgeInsets(top: 8, left: 16, bottom: 32, right: 16)
        collectionView.collectionViewLayout = flowLayout

        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        self.view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(itemType: CharacterCollectionViewItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.trackingDelegate = self

        selectionView.frame.size = NSSize(width: 50, height: 50)
        selectionView.wantsLayer = true
        selectionView.layer?.backgroundColor = NSColor.purple.withAlphaComponent(0.35).cgColor
        self.view.addSubview(selectionView)
    }

}


extension LookupResultViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withType: CharacterCollectionViewItem.self, for: indexPath)
        let result = results[indexPath.item]
        item.configure(character: result.character, pronunciation: result.pronunciation)
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let result = results[indexPath.item]
        return CharacterCollectionViewItem.defaultSize(for: result.character, pronunciation: result.pronunciation)
    }
}


extension LookupResultViewController: TrackingCollectionViewTrackingDelegate {
    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseEnteredWith event: NSEvent) {
        selectionView.isHidden = false
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseExitedWith event: NSEvent) {
        selectionView.isHidden = true
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseMovedWith event: NSEvent) {
        selectionView.isHidden = false
        selectionView.frame.origin = self.view.convert(event.locationInWindow, from: nil)
    }
}
