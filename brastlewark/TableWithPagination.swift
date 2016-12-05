//
//  TableWithPagination.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import Foundation
import UIKit

protocol TableWithPaginationDelegate {
    func startLoadingNextResults()
}

class TableWithPagination:UITableView {
    var paginatedDelegate:TableWithPaginationDelegate?
    
    override var contentOffset:CGPoint {
        didSet {
            func startLoadingNextResults() {
                let tableHeaderViewHeight = tableHeaderView?.bounds.height ?? 0
                let tableFooterViewHeight = tableFooterView?.bounds.height ?? 0
                let height = contentSize.height - contentInset.top - contentInset.bottom - nextPageLoaderOffset - bounds.height - tableHeaderViewHeight - tableFooterViewHeight
                
                
                if contentOffset.y > 0 && contentOffset.y > height && !loading && haveMoreData {
                    self.paginatedDelegate?.startLoadingNextResults()
                }
            }
            
            DispatchQueue.main.async  {
                startLoadingNextResults()
            }
        }
    }
    
    var loading:Bool = false
    var haveMoreData:Bool = false
    var nextPageLoaderOffset:CGFloat = 300
}

protocol GnomePaginatedController: class, TableWithPaginationDelegate {
    associatedtype T
    
    var tableView:TableWithPagination! { get set }
    var results:[T] { get set }
    
    var nextPageLoaderView:UIView! { get }
    
    func fetchResults(start:()->(), finish:(_ result:[T]?, _ error:Error?, _ haveMoreData:Bool)->())
    func fetchNextResults(start:()->(), finish:@escaping(_ result:[T]?, _ error:Error?, _ haveMoreData:Bool)->())
    func reloadData()
    func reloadNextData()
}


extension GnomePaginatedController {
    func startFetchingResults() {
        fetchResults(start: willFetchingResults, finish:didFetchResults)
    }
    
    func startLoadingNextResults() {
        fetchNextResults(start: willFetchingResults, finish:didFetchNextResults)
    }
    
    //MARK: privates
    
    func willFetchingResults() {
        tableView.loading = true
        tableView.tableFooterView = nextPageLoaderView
    }
    
    func didFetchResults(results:[T]?, error:Error?, haveMoreData:Bool) {
        if let _ = error {
            return didFailedToFetchResults()
        }
        
        tableView.loading = false
        tableView.haveMoreData = haveMoreData
        tableView.tableFooterView = haveMoreData ? nextPageLoaderView : nil
        
        endRefreshing(hasError: false)
        self.results = results ?? []
        reloadData()
    }
    
    func didFetchNextResults(results:[T]?, error:Error?, haveMoreData:Bool) {
        if let _ = error {
            return didFailedToFetchResults()
        }
        
        tableView.loading = false
        tableView.haveMoreData = haveMoreData
        tableView.tableFooterView = haveMoreData ? nextPageLoaderView : nil
        
        endRefreshing(hasError: false)
        self.results.append(contentsOf: results ?? [])
        reloadNextData()
    }
    
    func didFailedToFetchResults() {
        tableView.loading = false
        endRefreshing(hasError: true)
    }
    
    //MARK: overrides
    
    func endRefreshing(hasError:Bool) {
        
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadNextData() {
        let offset = tableView.contentOffset
        tableView.reloadData()
        tableView.setContentOffset(offset, animated: false)
    }
}
