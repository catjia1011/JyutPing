//
//  LookupResultViewController.swift
//  JyutPing
//
//  Created by Cat Jia on 23/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

private let kSelectionPadding = (horizontal: CGFloat(2), vertical: CGFloat(2))

struct SingleLookupResult {
    let character: Character
    let pronunciation: String
}

protocol LookupResultViewControllerDelegate: NSObjectProtocol {
    func lookupResultViewController(_ viewController: LookupResultViewController, didSelect character: Character) -> Void
}

class LookupResultViewController: NSViewController {

    weak var delegate: LookupResultViewControllerDelegate?

    private let scrollView = NSScrollView()
    private let flowLayout = NSCollectionViewFlowLayout()
    private let collectionView = TrackingCollectionView()
    private let selectionView = NSImageView()
    private let paperLineView = PaperLineView()

    var results: [SingleLookupResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func loadView() {
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = NSEdgeInsets(top: 13, left: 32, bottom: 32, right: 16)
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
        collectionView.isSelectable = false

        selectionView.frame.size = .zero
        selectionView.isHidden = true
        self.view.addSubview(selectionView, positioned: .below, relativeTo: nil)

        self.scrollView.contentView.addSubview(paperLineView, positioned: .below, relativeTo: nil)

        let selectionImage = NSImage(named: "CharacterSelection")
        selectionImage?.resizingMode = .stretch
        selectionImage?.capInsets = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        assert(selectionImage != nil, "selectionImage is not found")
        selectionView.image = selectionImage
        selectionView.imageScaling = .scaleAxesIndependently

        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        self.paperLineView.frame = self.collectionView.frame
    }

    @objc private func didReceiveNotification(_ notification: Notification) {
        switch notification.name {
        case NSView.boundsDidChangeNotification:
            guard notification.object as? NSView == scrollView.contentView else { return }
            // did scroll
            self.selectionView.isHidden = true
            self.paperLineView.frame = self.collectionView.frame

        default:
            break
        }
    }

    private func updateSelection(mouseLocation: NSPoint) {
        let locationInCollectionView = collectionView.convert(mouseLocation, from: nil)
        let frames = collectionView.indexPathsForVisibleItems().compactMap { collectionView.layoutAttributesForItem(at: $0)?.frame }
        if let frame = frames.first(where: { $0.contains(locationInCollectionView) }) {
            selectionView.frame = self.view.convert(frame, from: collectionView).insetBy(dx: -kSelectionPadding.horizontal, dy: -kSelectionPadding.vertical)
            selectionView.isHidden = false
        } else {
            selectionView.frame = .zero
            selectionView.isHidden = true
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
        // do nothing
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseExitedWith event: NSEvent) {
        selectionView.isHidden = true
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseMovedWith event: NSEvent) {
        self.updateSelection(mouseLocation: event.locationInWindow)
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseDraggedWith event: NSEvent) {
        self.updateSelection(mouseLocation: event.locationInWindow)
    }

    func trackingCollectionView(_ collectionView: TrackingCollectionView, mouseUpWith event: NSEvent) {
        let locationInCollectionView = collectionView.convert(event.locationInWindow, from: nil)
        guard let indexPath = collectionView.indexPathsForVisibleItems().first(where: { collectionView.layoutAttributesForItem(at: $0)?.frame.contains(locationInCollectionView) == true }) else { return }
        let result = results[indexPath.item]
        self.delegate?.lookupResultViewController(self, didSelect: result.character)
    }
}
