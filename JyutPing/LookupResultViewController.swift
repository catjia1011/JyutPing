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

    private let scrollView = NSScrollView()
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

        scrollView.documentView = collectionView
        self.view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(itemType: CharacterCollectionViewItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.trackingDelegate = self

        selectionView.frame.size = .zero
        selectionView.isHidden = true
        selectionView.wantsLayer = true
        selectionView.layer?.backgroundColor = NSColor.purple.withAlphaComponent(0.35).cgColor
        self.view.addSubview(selectionView)

        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func didReceiveNotification(_ notification: Notification) {
        switch notification.name {
        case NSView.boundsDidChangeNotification:
            guard notification.object as? NSView == scrollView.contentView else { return }
            self.selectionView.isHidden = true

        default:
            break
        }
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
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseExitedWith event: NSEvent) {
        selectionView.isHidden = true
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseMovedWith event: NSEvent) {
        let locationInCollectionView = collectionView.convert(event.locationInWindow, from: nil)
        let frames = collectionView.indexPathsForVisibleItems().compactMap { collectionView.layoutAttributesForItem(at: $0)?.frame }
        if let frame = frames.first(where: { $0.contains(locationInCollectionView) }) {
            selectionView.frame = self.view.convert(frame, from: collectionView)
            selectionView.isHidden = false
        } else {
            selectionView.frame = .zero
            selectionView.isHidden = true
        }
    }
}
