//
//  CoutryViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/17/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

protocol CountryPickerDelegate {
    func didSelecteCountry(country: Country)
}

class CountryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    var delegate: CountryPickerDelegate!
    var filteredCountries: [Country] = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.filteredCountries = Objects.countries
        
        self.buttonWidthConstraint.constant = 70
        self.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredCountries = Objects.countries
        } else {
            self.filteredCountries = Objects.countries.filter { ($0.name?.contains(searchText))! }
        }
        
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.CountryTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.CountryTableViewCell)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = self.filteredCountries[indexPath.row]
        if let delegate = self.delegate {
            delegate.didSelecteCountry(country: country)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.CountryTableViewCell) as? CountryTableViewCell {
            
            let country = self.filteredCountries[indexPath.row]
            cell.labelName.text = country.name
            cell.labelCode.text = "+" + country.dialing_code!
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
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
