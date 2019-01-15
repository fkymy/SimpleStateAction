//
//  ViewController.swift
//  SimpleStateAction
//
//  Created by Yuske Fukuyama on 2018/12/21.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class StateActionViewController: UITableViewController {

  struct State {
    var itemCount: Int
    var fetchingMore: Bool
    static let empty: State = State(itemCount: 20, fetchingMore: false)
  }
  
  enum Action {
    case beginBatchFetch
    case endBatchFetch(resultCount: Int)
  }
  
  fileprivate(set) var state: State = .empty
  
  init() {
    super.init(nibName: nil, bundle: nil)
    title = "BatchFetch"
    tableView.tableFooterView = UIView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowCount: Int = tableView.numberOfRows(inSection: 0)
    
    if state.fetchingMore && indexPath.row == rowCount - 1 {
      let cell: TailLoadingCell = TailLoadingCell(style: .default, reuseIdentifier: nil)
      return cell
    }
    
    let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = String(format: "[%1d.%1d]", indexPath.section, indexPath.row)
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: Int = state.itemCount
    if state.fetchingMore {
      count += 1
    }
    return count
  }
  
//  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let currentOffSetY = scrollView.contentOffset.y
//    let contentHeight = scrollView.contentSize.height
//    let screenHeight = UIScreen.main.bounds.height
//    let screenfullsBeforeBottom = (contentHeight - currentOffSetY) / screenHeight
//    if screenfullsBeforeBottom < 1.0 {
//      self.willBeginBatchFetch()
//    }
//  }

  private func willBeginBatchFetch() {
    DispatchQueue.main.async {
      let oldState = self.state
      self.state = StateActionViewController.handleAction(.beginBatchFetch, fromState: oldState)
      self.renderDiff(oldState)
    }
    
    StateActionViewController.fetchDataWithCompletion { resultCount in
      let action = Action.endBatchFetch(resultCount: resultCount)
      let oldState = self.state
      self.state = StateActionViewController.handleAction(action, fromState: oldState)
      self.renderDiff(oldState)
    }
  }
  
  private func renderDiff(_ oldState: State) {
    self.tableView.performBatchUpdates({
      let rowCountChange = state.itemCount - oldState.itemCount
      if rowCountChange > 0 {
        let indexPaths = (oldState.itemCount..<state.itemCount).map { index in
          IndexPath(row: index, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .none)
      } else if rowCountChange < 0 {
        assertionFailure("Deleting rows is not implemented. ")
      }
      
      if state.fetchingMore != oldState.fetchingMore {
        if state.fetchingMore {
          let spinnerIndexPath = IndexPath(row: state.itemCount, section: 0)
          tableView.insertRows(at: [ spinnerIndexPath ], with: .none)
        } else {
          let spinnerIndexPath = IndexPath(row: oldState.itemCount, section: 0)
          tableView.deleteRows(at: [ spinnerIndexPath ], with: .none)
        }
      }
    }, completion: nil)
  }
  
  private static func handleAction(_ action: Action, fromState state: State) -> State {
    var state = state
    
    switch action {
    case .beginBatchFetch:
      state.fetchingMore = true
    case let .endBatchFetch(resultCount):
      state.itemCount += resultCount
      state.fetchingMore = false
    }
    
    return state
  }
  
  private static func fetchDataWithCompletion(_ completion: @escaping (Int) -> Void) {
    let time = DispatchTime.now() + Double(Int64(TimeInterval(NSEC_PER_SEC) * 1.0)) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time) {
      let resultCount = Int(arc4random_uniform(20))
      completion(resultCount)
    }
  }
}

