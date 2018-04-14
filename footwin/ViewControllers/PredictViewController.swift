//
//  PredictViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import SwiftyJSON

class PredictViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var buttonViewRules: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showLoader()
        appDelegate.getConfig() { data in
            if let jsonData = data as Data? {
                if let json = String(data: jsonData, encoding: .utf8) {
                    if let dict = JSON.init(parseJSON: json).dictionary {
                        if let base_url = dict["base_url"] {
                            Services.setBaseUrl(url: base_url.stringValue)
                        }
                        if let media_url = dict["media_url"] {
                            Services.setMediaUrl(url: media_url.stringValue)
                        }
                        if let is_review = dict["is_review"] {
                            isReview = is_review.boolValue
                        }
                        if let countries = dict["countries"] {
                            if let jsonArray = countries.arrayObject as? [NSDictionary] {
                                for json in jsonArray {
                                    let country = _Country.init(dictionary: json)
                                    Objects.countries.append(country!)
                                }
                            }
                        }
                        if let teams = dict["teams"] {
                            if let jsonArray = teams.arrayObject as? [NSDictionary] {
                                for json in jsonArray {
                                    let team = Team.init(dictionary: json)
                                    Objects.teams.append(team!)
                                }
                            }
                        }
                        if let active_round = dict["active_round"] {
                            if let json = active_round.dictionaryObject as NSDictionary? {
                                Objects.activeRound = Round.init(dictionary: json)!
                            }
                        }
                    }
                }

                self.getMatches()
                
                DispatchQueue.main.async {
                    self.initializeViews()
                }
            }
        }
        
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func startTutorial(sender: UIButton) {
        if let helperView = sender.superview?.superview as? HelperView {
            UIView.animate(withDuration: 0.1, animations: {
                helperView.alpha = 0
            }, completion: { success in
                if let tutorialView = self.showView(name: Views.TutorialView) as? TutorialView {
                    tutorialView.showFirstTutorial()
                }
            })
        }
    }
    
    func getMatches() {
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getMatches()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["matches"] as? [NSDictionary] {
                            Objects.matches = [Match]()
                            for json in jsonArray {
                                let match = Match.init(dictionary: json)
                                Objects.matches.append(match!)
                            }
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
                    
                    if let helperView = self.showView(name: Views.HelperView) as? HelperView {
                        helperView.buttonStartTutorial.addTarget(self, action: #selector(self.startTutorial(sender:)), for: .touchUpInside)
                    }
                }
            }
        }
    }
    
    func initializeViews() {
        self.imageProfile.isUserInteractionEnabled = true
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(navigateToNotifications))
        self.imageProfile.addGestureRecognizer(tap)

        self.labelCoins.text = currentUser.coins
        self.labelWinningCoins.text = currentUser.winning_coins
        
        self.labelRound.text = Objects.activeRound.title
        
        if let avatar = currentUser.avatar {
            self.imageProfile.kf.setImage(with: URL(string: avatar))
        }
        
        self.labelBadge.layer.cornerRadius = self.labelBadge.frame.size.width/2
        self.labelBadge.clipsToBounds = true
    }
    
    @objc func navigateToNotifications() {
        self.redirectToVC(storyboardId: StoryboardIds.NotificationsViewController, type: .present)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.PredictionTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.PredictionTableViewCell)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PredictionTableViewCell) as? PredictionTableViewCell {
            cell.selectionStyle = .none
            
            let exactScoreTap = UITapGestureRecognizer(target: self, action: #selector(exactScoreTapped(sender:)))
            cell.viewExactScore.addGestureRecognizer(exactScoreTap)
            cell.viewExactScore.tag = indexPath.row
            
            cell.viewConfirm.layer.cornerRadius = cell.viewConfirm.frame.size.width/2
            
            let homeTap = UITapGestureRecognizer(target: self, action: #selector(homeTapped(sender:)))
            cell.homeImage.addGestureRecognizer(homeTap)
            cell.homeImage.tag = indexPath.row
            
            let awayTap = UITapGestureRecognizer(target: self, action: #selector(awayTapped(sender:)))
            cell.awayImage.addGestureRecognizer(awayTap)
            cell.awayImage.tag = indexPath.row
            
            let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapoed(sender:)))
            cell.viewConfirm.addGestureRecognizer(confirmTap)
            cell.viewConfirm.tag = indexPath.row
            
            cell.buttonDraw.customizeBorder(color: Colors.white, border: 2.0)
            cell.buttonDraw.addTarget(self, action: #selector(drawTapped(sender:)), for: .touchUpInside)
            cell.buttonDraw.tag = indexPath.row
            
            let match = Objects.matches[indexPath.row]
            if let homeFlag = match.home_flag {
//                cell.homeImage.kf.setImage(with: URL(string: homeFlag))
            }
            if let awayFlag = match.away_flag {
//                cell.awayImage.kf.setImage(with: URL(string: awayFlag))
            }
            cell.labelHome.text = match.home_name
            cell.labelAway.text = match.away_name
           
            cell.buttonDraw.backgroundColor = .clear
            cell.buttonDraw.isEnabled = true
            
            if match.selectedTeam == "home" {
                cell.homeWidthConstraint.constant = 100
                cell.homeShadowWidthConstraint.constant = 120
                cell.homeShadow.alpha = 1
                cell.awayWidthConstraint.constant = 80
                cell.awayShadowWidthConstraint.constant = 110
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if match.selectedTeam == "away" {
                cell.awayWidthConstraint.constant = 100
                cell.awayShadowWidthConstraint.constant = 120
                cell.awayShadow.alpha = 1
                cell.homeWidthConstraint.constant = 80
                cell.homeShadowWidthConstraint.constant = 110
                cell.homeShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if match.selectedTeam == "draw" {
                cell.homeWidthConstraint.constant = 90
                cell.homeShadowWidthConstraint.constant = 110
                cell.homeShadow.alpha = 0
                cell.awayWidthConstraint.constant = 90
                cell.awayShadowWidthConstraint.constant = 110
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                
                cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
                cell.buttonDraw.backgroundColor = Colors.appBlue
                cell.buttonDraw.isEnabled = false
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            if match.confirmed != nil && match.confirmed! {
                cell.viewConfirm.alpha = 0
                cell.labelVS.alpha = 1
                cell.labelVS.text = "CONFIRMED"
                cell.labelVS.font = Fonts.textFont_Bold
                cell.isUserInteractionEnabled = false
                cell.contentView.isEnabled(enable: false)
            } else {
                cell.labelVS.text = "VS"
                cell.labelVS.font = Fonts.textFont_Bold_XLarge
                cell.isUserInteractionEnabled = true
                cell.contentView.isEnabled(enable: true)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func exactScoreTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let exactScoreView = self.showView(name: Views.ExactScoreView) as? ExactScoreView {
                let match = Objects.matches[view.tag]
                if let homeFlag = match.home_flag {
                    exactScoreView.homeImage.kf.setImage(with: URL(string: homeFlag))
                }
                if let awayFlag = match.away_flag {
                    exactScoreView.awayImage.kf.setImage(with: URL(string: awayFlag))
                }
                exactScoreView.labelHome.text = match.home_name
                exactScoreView.labelAway.text = match.away_name
                
                exactScoreView.textFieldHome.layer.cornerRadius = 10
                exactScoreView.textFieldAway.layer.cornerRadius = 10
            }
        }
    }
    
    @objc func homeTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            Objects.matches[view.tag].selectedTeam = "home"
            tableView.reloadData()
        }
    }
    
    @objc func awayTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            Objects.matches[view.tag].selectedTeam = "away"
            tableView.reloadData()
        }
    }
    
    @objc func drawTapped(sender: UIButton) {
        Objects.matches[sender.tag].selectedTeam = "draw"
        tableView.reloadData()
    }
    
    @objc func confirmTapoed(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            self.showAlertView(title: "", message: "ARE YOU SURE YOU WANT TO CONFIRM THE PREDICTION? \nONCE CONFIRMED YOU CANNOT EDIT IT!!", cancelTitle: "EDIT", doneTitle: "CONFIRM")
            self.alertView.buttonDone.addTarget(self, action: #selector(confirmPrediction(sender:)), for: .touchUpInside)
            self.alertView.buttonDone.tag = view.tag
        }
    }
    
    @objc func confirmPrediction(sender: UIButton) {
        Objects.matches[sender.tag].confirmed = true
        tableView.reloadData()
    }
    
    @IBAction func buttonViewRulesTapped(_ sender: Any) {
        if let rulesView = self.showView(name: Views.RulesView) as? RulesView {
            rulesView.labelPredict.text = Objects.activeRound.prediction_coins! + "\nCoins"
            rulesView.labelWin.text = Objects.activeRound.winning_coins! + "\nCoins"
            rulesView.labelExactScore.text = Objects.activeRound.exact_score_coins! + "\nCoins"
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
