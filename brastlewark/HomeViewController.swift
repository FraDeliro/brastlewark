//
//  ViewController.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit
import EasyTipView

enum GnomeID {
    case Man
    case Woman
}

private let GnomeTableID = "GnomeTableController"

class HomeViewController: UIViewController, CAPSPageMenuDelegate, GnomeTableDelegate, FiltersTableViewDelegate, EasyTipViewDelegate {
    
    //MARK: - Outlets & Variables
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    var dataArray = [Gnome]()
    var gnomeManArray = [Gnome]()
    var gnomeWomanArray = [Gnome]()
    var originalWomenArray = [Gnome]()
    
    var gnomeManController = GnomeTableController()
    var gnomeWomanController = GnomeTableController()
    
    var currentFilter = Filter(type: .InActive)
    var easyTipView: EasyTipView?
    
    @IBOutlet var filterBarButtonItem: UIBarButtonItem!

    //MARK: - Page lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gnomeManController = (self.storyboard?.instantiateViewController(withIdentifier: GnomeTableID) as! GnomeTableController?)!
        gnomeWomanController = (self.storyboard?.instantiateViewController(withIdentifier: GnomeTableID) as! GnomeTableController?)!
        
        self.setUpPageMenu()
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        easyTipView?.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Custom Accessors
    
    func fetchData() {
    ApiEngine.shared.getBrastlewarkGnomes(succedeedBlock: { (response) in
        self.dataArray = response as! [Gnome]
        for gnome in self.dataArray {
            if gnome.gender == .man {
            self.gnomeManArray.append(gnome)
            } else {
            self.gnomeWomanArray.append(gnome)
            }
        }
        self.gnomeManController.getData(array: self.gnomeManArray)
        self.gnomeManController.startFetchingResults()
    }) { (error) in
        _ = SweetAlert.shared.presentSweetAlert(error)
        }
    
    }
    
    func setUpPageMenu() {
        
        gnomeManController.title = "Men"
        gnomeManController.delegate = self
        gnomeManController.defaultID = GnomeID.Man.hashValue
        gnomeManController.selectedMenuImage = #imageLiteral(resourceName: "gnomeM")
        gnomeManController.unselectedMenuImage = #imageLiteral(resourceName: "gnomeM")
        gnomeManController.dataArray = self.gnomeManArray
        
        
        gnomeWomanController.title = "Women"
        gnomeWomanController.delegate = self
        gnomeWomanController.defaultID = GnomeID.Woman.hashValue
        gnomeWomanController.selectedMenuImage = #imageLiteral(resourceName: "gnomeW")
        gnomeWomanController.unselectedMenuImage = #imageLiteral(resourceName: "gnomeW")
        gnomeWomanController.dataArray = self.gnomeWomanArray
        

        controllerArray.append(gnomeManController as UIViewController)
        controllerArray.append(gnomeWomanController as UIViewController)
        
        // Customize page menu
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(1.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.5),
            .menuHeight(60),
            .selectedMenuItemLabelColor(UIColor.accentColor()),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.accentColor()),
            .selectionIndicatorHeight(2.0),
            .addBottomMenuHairline(true),
            .bottomMenuHairlineColor(UIColor.lightGray)//,
            //.menuItemFont(UIFont(name: "", size: 14)!)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    func showEasyTipView() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.accentColor()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        
        easyTipView = EasyTipView(text: "Turned On Filters", preferences: preferences, delegate: self)
        easyTipView?.show(animated: true, forItem: filterBarButtonItem, withinSuperView: nil)
    }
    
    //MARK: - EasyTipViewDelegate
    
    //required
    func easyTipViewDidDismiss(_ tipView : EasyTipView) {
        
    }
    
    //MARK: - Filters Functions
    
    func applyAllFiltersForArray(array: [Gnome]) -> [Gnome] {
        
        var filtered_gnomes = array
        filtered_gnomes = self.sortArrayForBaseOrder(array: filtered_gnomes, order: self.currentFilter.baseOrder ?? OrderType.Age)
        
        filtered_gnomes = filtered_gnomes.filter(self.filteredForAgeRange)
        
        filtered_gnomes = filtered_gnomes.filter(self.filteredForHeightRange)
        
        filtered_gnomes = filtered_gnomes.filter(self.filteredForWeightRange)
        
        return filtered_gnomes
    }
    
    func sortArrayForBaseOrder(array: [Gnome], order: OrderType) -> [Gnome] {
        
        var gnomes = [Gnome]()
        switch order {
        case .Age:
            gnomes = array.sorted(by: self.sortedForAge)
            return gnomes
        case .Name:
            gnomes = array.sorted(by: self.sortedForName)
            return gnomes
        }
    }

    func sortedForName(this:Gnome, that:Gnome) -> Bool {
        return this.name?.components(separatedBy: " ").first! ?? "" <= that.name?.components(separatedBy: " ").first! ?? ""
    }
    
    func sortedForAge(this:Gnome, that:Gnome) -> Bool {
        return this.age ?? 0 <= that.age ?? 0
    }
    
    func filteredForAgeRange(this:Gnome) -> Bool {
        return this.age ?? 0 >= currentFilter.ageLowerValue ?? 0 && this.age ?? 0 <= currentFilter.ageUpperValue ?? 100
    }
    
    func filteredForHeightRange(this:Gnome) -> Bool {
        return this.height ?? 0 >= currentFilter.heightLowerValue ?? 0 && this.height ?? 0 <= currentFilter.heightUpperValue ?? 100
    }
    
    func filteredForWeightRange(this:Gnome) -> Bool {
        return this.weight ?? 0 >= currentFilter.weightLowerValue ?? 0 && this.weight ?? 0 <= currentFilter.weightUpperValue ?? 100
    }
    
    // MARK: - IBActions
    
    @IBAction func showFiltersAction(_ sender: Any) {
        if self.dataArray.count > 0 {
            self.performSegue(withIdentifier: "showFilters", sender: self)
        }
    }
    
    //MARK: Page Menu Delegate
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 1 {
            self.gnomeWomanController.getData(array: self.gnomeWomanArray)
            self.gnomeWomanController.startFetchingResults()
        }
    }
    
    //MARK: GnomeTableDelegate
    func showDetailForGnome(gnome: Gnome) {
        self.performSegue(withIdentifier: "showDetail", sender: gnome)
    }
    
    //MARK: Filter Delegate
    func reloadDataWithFilters(filter: Filter) {
        currentFilter = filter.getSavedFilter()
        originalWomenArray = self.gnomeWomanArray
        if ((self.currentFilter.type == FilterType.Active)) {
            self.showEasyTipView()
            let gnomeMenFiltered = self.applyAllFiltersForArray(array: self.gnomeManArray)
            self.gnomeManController.getData(array: gnomeMenFiltered)
            self.gnomeManController.moreData = false
            self.gnomeManController.startFetchingResults()
            let gnomeWomenFiltered = self.applyAllFiltersForArray(array: originalWomenArray)
            self.gnomeWomanArray = gnomeWomenFiltered
            self.gnomeWomanController.moreData = false
        } else {
        }
    }
    
    func removeFilters() {
        self.gnomeManController.getData(array: self.gnomeManArray)
        self.gnomeManController.moreData = true
        self.gnomeManController.startFetchingResults()
        self.gnomeWomanController.moreData = true
        self.gnomeWomanArray = originalWomenArray
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detail = segue.destination as! GnomeDetailController
            detail.gnome = sender as! Gnome?
        } else if segue.identifier == "showFilters" {
            let detail = segue.destination as! FiltersTableViewController
            detail.gnomes = self.dataArray
            detail.delegate = self
        }
    }
    

}

