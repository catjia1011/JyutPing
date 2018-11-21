//
//  OutlineNode.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

extension OutlineNode {
    enum Value: Equatable {
        case section(title: String)
        case lookup(text: String)
    }
}

class OutlineNode {
    let isLeaf: Bool
    let value: Value?
    private(set) var children: [OutlineNode] = []

    init(value: Value?, children: [OutlineNode]) {
        self.isLeaf = false
        self.value = value
        self.children = children
    }

    init(valueAsLeaf value: Value?) {
        self.isLeaf = true
        self.value = value
        self.children = []
    }

    func updateChildren(_ block: (_ children: inout [OutlineNode]) -> Void) {
        if self.isLeaf {
            assertionFailure("a leaf node always returns empty children which cannot be changed")
            return
        }
        block(&children)
    }
}
