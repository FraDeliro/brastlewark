//
//  FiltersTableViewController.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

protocol FiltersTableViewDelegate {
    func reloadDataWithFilters(filter: Filter)
    func removeFilters()
}

private let OrderCellID = "OrderTableViewCell"
private let FilterAgeCellID = "FilterAgeTableViewCell"
private let FilterHeightCellID = "FilterHeightTableViewCell"
private let FilterWeightCellID = "FilterWeightTableViewCell"

class FiltersTableViewController: UITableViewController {

    //MARK: - Outlets & Variables
    var delegate: FiltersTableViewDelegate?
    var headerTitlesArray = ["ORDER BY:", "FILTER BY:"]
    var gnomes = [Gnome]()
    var filter: Filter?

    //MARK: - Page lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to avoid problems with slider
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        let reset = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(FiltersTableViewController.resetFilterAction))
        self.navigationItem.rightBarButtonItem = reset

        tableView.register(UINib(nibName: OrderCellID, bundle: Bundle.main), forCellReuseIdentifier: OrderCellID)
        tableView.register(UINib(nibName: FilterAgeCellID, bundle: Bundle.main), forCellReuseIdentifier: FilterAgeCellID)
        tableView.register(UINib(nibName: FilterHeightCellID, bundle: Bundle.main), forCellReuseIdentifier: FilterHeightCellID)
        tableView.register(UINib(nibName: FilterWeightCellID, bundle: Bundle.main), forCellReuseIdentifier: FilterWeightCellID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filter?.removeSavedFilters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions

    func resetFilterAction() {
        preference.set(false, forKey: "FirstAgeFilterLunch")
        preference.set(false, forKey: "FirstHeightFilterLunch")
        preference.set(false, forKey: "FirstWeightFilterLunch")
        filter?.removeSavedFilters()
        delegate?.removeFilters()
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: - IBActions

    @IBAction func filtersAction(_ sender: Any) {

        let orderCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! OrderTableViewCell
        let filterAgeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FilterAgeTableViewCell
        let filterHeightCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! FilterHeightTableViewCell
        let filterWeightCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! FilterWeightTableViewCell

        let order = orderCell.getOrder()
        let ageLower = filterAgeCell.getValues()[0]
        let ageUpper = filterAgeCell.getValues()[1]
        let heightLower = filterHeightCell.getValues()[0]
        let heightUpper = filterHeightCell.getValues()[1]
        let weightLower = filterWeightCell.getValues()[0]
        let weightUpper = filterWeightCell.getValues()[1]


        filter = Filter(type: .Active)
        filter?.setFilter(baseOrder: order, ageLowerValue: ageLower, ageUpperValue: ageUpper, heightLowerValue: heightLower, heightUpperValue: heightUpper, weightLowerValue: weightLower, weightUpperValue: weightUpper)
        delegate?.reloadDataWithFilters(filter: filter!)
       _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 1:
            return 3
        default:
            return 1
        }
    }

    //MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        header.backgroundColor = UIColor.colorFromRGB(0xF6F6F6)

        let titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: tableView.bounds.width, height: 30))
        titleLabel.text = headerTitlesArray[section]
        titleLabel.textColor = UIColor.gray
        header.addSubview(titleLabel)

        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID) as! OrderTableViewCell
            //set the data here
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterAgeCellID) as! FilterAgeTableViewCell
                //set the data here
                cell.configureCell(gnomes: gnomes)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterHeightCellID) as! FilterHeightTableViewCell
                //set the data here
                cell.configureCell(gnomes: gnomes)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterWeightCellID) as! FilterWeightTableViewCell
                //set the data here
                cell.configureCell(gnomes: gnomes)
                return cell
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
