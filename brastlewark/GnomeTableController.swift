//
//  MenuTableViewController.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

protocol GnomeTableDelegate {
    func showDetailForGnome(gnome: Gnome)
}

private let GnomeCellID = "GnomeTableViewCell"

class GnomeTableController: UIViewController, UITableViewDataSource, UITableViewDelegate, GnomePaginatedController {

    //MARK: - Outlets & Variables
    var delegate: GnomeTableDelegate?

    internal var results: [Gnome] = []
    @IBOutlet var nextPageLoaderView: UIView!
    var dataArray = [Gnome]()
    @IBOutlet var tableView: TableWithPagination!
    @IBOutlet var buttonBacktoTop: UIButton!
    var lastOffsetY: CGFloat = 0
    var moreData = true
    var noResults = false

    //MARK: - Page lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.paginatedDelegate = self
        tableView.register(UINib(nibName: GnomeCellID, bundle: Bundle.main), forCellReuseIdentifier: GnomeCellID)
        buttonBacktoTop.isHidden = true
        buttonBacktoTop.layer.zPosition = 1
        buttonBacktoTop.layer.shadowColor = UIColor.lightGray.cgColor
        buttonBacktoTop.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Custom Accessors
    func getData(array: [Gnome]) {
        noResults = true
        self.dataArray = array
    }

    func fetchData() -> [Gnome] {
        return self.dataArray
    }

    // MARK: - IBActions
    @IBAction func backToTopAction(_ sender: UIButton) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .transitionCrossDissolve, animations: {
            self.buttonBacktoTop.alpha = 0.0
        }) { (success) in
            self.buttonBacktoTop.isHidden = true
            self.buttonBacktoTop.alpha = 1.0
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if results.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return results.count
        } else {
            if !noResults {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return 6
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "No Results"
                noDataLabel.textColor = UIColor.accentColor()
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 1
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
                return 0
            }
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GnomeCellID, for: indexPath) as! GnomeTableViewCell
        if results.count > 0 {
            Loader.removeLoaderFromViews(views: cell.subviews)
            cell.configureCell(gnome: results[indexPath.row])
        } else {
            Loader.addLoaderToViews(views: cell.subviews)
        }
        // Configure the cell...

        return cell
    }

    //MARK: Scroll Delegate Methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = scrollView.contentOffset.y
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let hide = scrollView.contentOffset.y > self.lastOffsetY
        buttonBacktoTop.isHidden = hide
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
          buttonBacktoTop.isHidden = true
        }
    }

    //MARK: - Table View Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let gnome = results[indexPath.row]
        delegate?.showDetailForGnome(gnome: gnome)
    }

    //MARK: - Paginated Delegate

    // service logic for calling apis
    func fetchResults(start: () -> (), finish: (_ result: [Gnome]?, _ error: Error?, _ haveMoreData: Bool) -> ()) {
        start()
        finish(self.fetchData(), nil, moreData)
    }

    // method called when we scroll to bottom and will return nextpage items
    internal func fetchNextResults(start: () -> (), finish: @escaping ([Gnome]?, Error?, Bool) -> ()) {
        start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            finish(self.fetchData(), nil, self.moreData)
        }
    }

    func reloadData() {
       // tableView.reloadData()
        tableView.reloadSections([0], with: UITableViewRowAnimation.fade)
    }

    func reloadNextData() {
        tableView.reloadData()
    }
}
