//
//  MainViewController+CollectionView.swift
//  JyutPing
//
//  Created by Cat Jia on 22/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

private var kJyutDictKey = ""
extension MainViewController {
    private typealias JyutDict = NSDictionary // [String: [String: Int]]; NSDictionary is much faster for lookup
    private typealias JyutDictValue = [String: Int]
    private var jyutDict: JyutDict? {
        set { objc_setAssociatedObject(self, &kJyutDictKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &kJyutDictKey) as? JyutDict }
    }


    func initializeCollectionView() {
        self.collectionView.register(itemType: CharacterCollectionViewItem.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        // load JyutDict
        // open data `JyutDict.json` is from https://words.hk/faiman/analysis/existingcharpronunciations
        if let url = Bundle.main.url(forResource: "JyutDict", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JyutDict {
            self.jyutDict = dict
        } else {
            assertionFailure("unexpected when loading JyutDict")
        }
    }
}


extension MainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
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
