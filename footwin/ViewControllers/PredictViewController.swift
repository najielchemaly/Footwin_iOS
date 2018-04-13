//
//  PredictViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class PredictViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var buttonViewRules: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMatches()
        self.initializeViews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMatches() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getMatches()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let jsonArray = response?.json {
                        Objects.matches = [Match]()
                        for json in jsonArray {
                            let match = Match.init(dictionary: json)
                            Objects.matches.append(match!)
                        }
                    }
                } else {
                    if let message = response?.message {
                        self.showAlertView(message: message)
                    }
                }
                
                self.hideLoader()
                self.refreshControl.endRefreshing()
                
                if Objects.matches.count == 0 {
                    self.addEmptyView(message: "Something went wrong, try to refresh the page", frame: self.tableView.frame)
                } else {
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func initializeViews() {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2

        self.labelCoins.text = currentUser.coins
        self.labelWinningCoins.text = currentUser.winning_coins
        
        self.labelRound.text = Objects.activeRound.title
        
        if let avatar = currentUser.avatar {
            self.imageProfile.kf.setImage(with: URL(string: avatar))
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIdentifiers.PredictionTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.PredictionTableViewCell)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleRefresh(fromNotification: Bool = false) {
        if Objects.matches.count == 0 {
            self.showLoader()
        }
        
        self.getMatches()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Objects.matches.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PredictionTableViewCell) as? PredictionTableViewCell {
            
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func buttonViewRulesTapped(_ sender: Any) {
        
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
