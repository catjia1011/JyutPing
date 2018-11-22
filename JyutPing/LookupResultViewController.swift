//
//  LookupResultViewController.swift
//  JyutPing
//
//  Created by Cat Jia on 23/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Cocoa

class LookupResultViewController: NSViewController {
    private typealias JyutDict = NSDictionary // [String: [String: Int]]; NSDictionary is much faster for lookup
    private typealias JyutDictValue = [String: Int]
    private var jyutDict: JyutDict?

    private let flowLayout = NSCollectionViewFlowLayout()
    private let collectionView = NSCollectionView()

    override func loadView() {
        collectionView.collectionViewLayout = flowLayout

        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        self.view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // load JyutDict
        // open data `JyutDict.json` is from https://words.hk/faiman/analysis/existingcharpronunciations
        if let url = Bundle.main.url(forResource: "JyutDict", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JyutDict {
            self.jyutDict = dict
        } else {
            assertionFailure("unexpected when loading JyutDict")
        }

        collectionView.register(itemType: CharacterCollectionViewItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}


extension LookupResultViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withType: CharacterCollectionViewItem.self, for: indexPath)
        return item
    }
}
