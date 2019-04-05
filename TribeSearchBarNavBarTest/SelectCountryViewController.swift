//
//  SelectCountryViewController.swift
//  TribeSearchBarNavBarTest
//
//  Created by Richmond Ko on 05/04/2019.
//  Copyright © 2019 Richmond Ko. All rights reserved.
//

import UIKit
    
class SelectCountryViewController: UIViewController {

    private let search = UISearchController(searchResultsController: nil)
    private static let COUNTRY_CELL = "countryCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select\nCountry"
        configureTableView()
        // show search bar instantly upon presentation
        navigationItem.hidesSearchBarWhenScrolling = false
        configureNavigationBar()
        configureSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        // to make search field background white
        setSearchFieldBackgroundColor()
        resizeLargeTitleAndScroll()
        //configureRegularSizeNavigationBarLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hides search bar when scrolling
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
    }
    
    private func configureRegularSizeNavigationBarLabel() {
        for subview in (navigationController?.navigationBar.subviews)! {
            for sub in subview.subviews {
                if let label = sub as? UILabel {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    label.sizeToFit()
                }
            }
        }
    }
    
    private func configureSearchBar() {
        search.searchBar.delegate = self
        self.search.searchBar.backgroundColor = UIColor.white
        self.search.searchBar.barTintColor = UIColor.white
        self.search.searchBar.placeholder = "Search Country List"
        self.search.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        setSearchFieldBackgroundColor()
    }
    
    private func setSearchFieldBackgroundColor() {
        if let textField = search.searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.borderWidth = 0.5
            textField.layer.cornerRadius = 10.0
            if let backgroundView = textField.subviews.first {
                backgroundView.backgroundColor = UIColor.white
                for subView in backgroundView.subviews {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    //works but cuts the regular size title label
    private func resizeLargeTitleAndScroll() {
        if let navBarSubviews = navigationController?.navigationBar.subviews {
            for subView in navBarSubviews where NSStringFromClass(type(of: subView)).contains("LargeTitle"){
                if let label = subView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    let oldLabelHeight = label.frame.size.height
                    let largeTitleSubviewContentWidth = subView.frame.size.width - subView.layoutMargins.left - subView.layoutMargins.right
                    let properlySizedLabel = label.sizeThatFits(CGSize(width: largeTitleSubviewContentWidth, height: CGFloat.greatestFiniteMagnitude))
                    label.frame.size = properlySizedLabel
                    let labelHeightDiff = label.frame.size.height - oldLabelHeight
                    let needsResize = label.frame.size.height > subView.frame.size.height
                    if needsResize {
                        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y-labelHeightDiff), animated: true)
                    }
                }
            }
        }
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = nil
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectCountryViewController.COUNTRY_CELL, for: indexPath)
        cell.textLabel?.text = "Philippines"
        return cell
    }
}

extension SelectCountryViewController: UISearchBarDelegate {
    
}
