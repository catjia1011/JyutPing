//
//  MainViewController+OutlineView.swift
//  JyutPing
//
//  Created by Cat Jia on 20/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation
import AppKit

// sync with storyboard
private extension NSUserInterfaceItemIdentifier {
    static let headerCell = NSUserInterfaceItemIdentifier(rawValue: "HeaderCell")
    static let dataCell = NSUserInterfaceItemIdentifier(rawValue: "DataCell")
}

private var kBaseNodeKey = ""
private var kHistoryNodeKey = ""
extension MainViewController {
    private var historyNode: OutlineNode {
        return self.lazyAssociated(&kHistoryNodeKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
            OutlineNode(value: .section(title: "History"), children: [])
        }
    }

    private var baseNode: OutlineNode {
        return self.lazyAssociated(&kBaseNodeKey, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
            OutlineNode(value: nil, children: [
                historyNode
            ])
        }
    }

    func initializeOutlineView() {
        self.loadSavedLookupHistory()

        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.reloadData()
        outlineView.expandItem(historyNode)
    }

    func addLookupHistory(text: String) {
        historyNode.updateChildren { (children) in
            let item: OutlineNode.Value = .lookup(text: text)
            children.removeAll { $0.value == item }
            if text != "" {
                children.insert(OutlineNode(valueAsLeaf: item), at: 0)
            }
        }

        self.outlineView.reloadData()
        self.saveLookupHistory()
    }

    private func loadSavedLookupHistory() {
        guard let stringArray = UserDefaults.standard.stringArray(forKey: UserDefaultsKey.lookupHistory) else { return }
        historyNode.updateChildren { (children) in
            children = stringArray.map {
                OutlineNode(valueAsLeaf: .lookup(text: $0))
            }
        }
    }

    private func saveLookupHistory() {
        let stringArray: [String] = historyNode.children.compactMap {
            guard let value = $0.value, case let .lookup(text: text) = value else { return nil }
            return text
        }
        UserDefaults.standard.set(stringArray, forKey: UserDefaultsKey.lookupHistory)
    }
}


extension MainViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return (item as? OutlineNode ?? baseNode).children.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return (item as? OutlineNode ?? baseNode).children[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let item = item as! OutlineNode
        return !item.isLeaf
    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        let item = item as! OutlineNode
        guard let value = item.value else { return false }

        switch value {
        case .section:
            return true

        case .lookup:
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let item = item as! OutlineNode
        guard let value = item.value else { return nil }

        switch value {
        case .section(title: let title):
            let cellView = outlineView.makeView(withIdentifier: .headerCell, owner: self) as? OutlineHeaderCellView
            cellView?.textField?.stringValue = title
            cellView?.delegate = self
            return cellView

        case .lookup(text: let text):
            let cellView = outlineView.makeView(withIdentifier: .dataCell, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = text
            return cellView
        }
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        let item = item as! OutlineNode
        guard let value = item.value else { return false }

        switch value {
        case .section:
            return false

        case .lookup:
            return true
        }
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView, outlineView == self.outlineView else { return }
        guard let item = outlineView.item(atRow: outlineView.selectedRow) as? OutlineNode else { return }
        guard let value = item.value else { return }

        switch value {
        case .section:
            assertionFailure("unexpected")

        case .lookup(text: let text):
            self.displayText(text)
        }
    }
}


extension MainViewController: OutlineHeaderCellViewDelegate {
    func outlineHeaderCellView(_ cellView: OutlineHeaderCellView, didTapClearButton clearButton: NSButton) {
        self.historyNode.updateChildren { (children) in
            children.removeAll()
        }
        self.outlineView.reloadData()
        self.saveLookupHistory()
    }
}
