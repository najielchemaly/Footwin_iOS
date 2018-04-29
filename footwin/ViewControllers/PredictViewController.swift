//
//  PredictViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseMessaging
import CountdownLabel

class PredictViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var buttonViewRules: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCoins: UIImageView!
    
    var refreshControl = UIRefreshControl()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNotificationBadgeNumber(label: labelBadge)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Messaging.messaging().subscribe(toTopic: "/topics/footwinnews")
        
        DispatchQueue.global(qos: .background).async {
            appDelegate.services.updateFirebaseToken()
        }
        
        self.getPackages()
    }
    
    @objc func startTutorial(sender: UIButton) {
        if let helperView = sender.superview?.superview as? HelperView {
            UIView.animate(withDuration: 0.1, animations: {
                helperView.alpha = 0
            }, completion: { success in
                if let tutorialView = self.showView(name: Views.TutorialView) as? TutorialView {                    
                    tutorialView.imageProfile.layer.cornerRadius = tutorialView.imageProfile.frame.size.width/2
                    tutorialView.imageProfile.image = self.imageProfile.image
                    if let match = Objects.matches.first {
                        if let homeFlag = match.home_flag, !homeFlag.isEmpty {
                            tutorialView.imageHome.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
                        }
                        if let homeName = match.home_name {
                            tutorialView.labelHome.text = homeName
                        }
                    }
                    tutorialView.showFirstTutorial()
                }
            })
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "didShowHelper")
            userDefaults.synchronize()
        }
    }
    
    func getMatches() {
        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getMatches()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if Objects.predictions.count == 0 {
                            if let jsonArray = json["matches"] as? [NSDictionary] {
                                Objects.matches = [Match]()
                                for json in jsonArray {
                                    let match = Match.init(dictionary: json)
                                    Objects.matches.append(match!)
                                }
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
                    
                    // TODO
                    if !UserDefaults.standard.bool(forKey: "didShowHelper") {
                        if let helperView = self.showView(name: Views.HelperView) as? HelperView {
                            if let username = currentUser.username {
                                if let text = tutorialText {
                                    helperView.labelTitle.text = "HELLO " + username + ", " + text
                                }
                            }
                            
                            helperView.buttonStartTutorial.addTarget(self, action: #selector(self.startTutorial(sender:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
    }
    
    func initializeViews() {
        self.imageProfile.isUserInteractionEnabled = true
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(navigateToNotifications))
        self.imageProfile.addGestureRecognizer(profileTap)

        let coinsTap = UITapGestureRecognizer(target: self, action: #selector(navigateToCoinStash))
        self.imageCoins.addGestureRecognizer(coinsTap)
        
        self.labelCoins.text = currentUser.coins
        self.labelWinningCoins.text = currentUser.winning_coins
        
        self.labelRound.text = Objects.activeRound.title
        
        if let avatar = currentUser.avatar, !avatar.isEmpty {
            self.imageProfile.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
        } else {
            if let gender = currentUser.gender, gender.lowercased() == "male" {
                self.imageProfile.image = #imageLiteral(resourceName: "avatar_male")
            } else if let gender = currentUser.gender, gender.lowercased() == "female" {
                self.imageProfile.image = #imageLiteral(resourceName: "avatar_female")
            }
        }
        
        self.labelBadge.layer.cornerRadius = self.labelBadge.frame.size.width/2
        self.labelBadge.clipsToBounds = true
        
        self.setNotificationBadgeNumber(label: self.labelBadge)
        
        Objects.predictions = [Prediction]()
    }
    
    @objc func navigateToNotifications() {
        self.redirectToVC(storyboardId: StoryboardIds.NotificationsViewController, type: .present)
    }
    
    @objc func navigateToCoinStash() {
        self.redirectToVC(storyboardId: StoryboardIds.CoinStashViewController, type: .present)
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
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PredictionTableViewCell) as? PredictionTableViewCell {
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
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
            
            let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped(sender:)))
            cell.viewConfirm.addGestureRecognizer(confirmTap)
            cell.viewConfirm.tag = indexPath.row
            
            cell.buttonDraw.customizeBorder(color: Colors.white)
            cell.buttonDraw.addTarget(self, action: #selector(drawTapped(sender:)), for: .touchUpInside)
            cell.buttonDraw.tag = indexPath.row
            
            let match = Objects.matches[indexPath.row]
            if let homeFlag = match.home_flag, !homeFlag.isEmpty {
                cell.homeImage.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
            }
            if let awayFlag = match.away_flag, !awayFlag.isEmpty {
                cell.awayImage.kf.setImage(with: URL(string: Services.getMediaUrl() + awayFlag))
            }
            cell.labelHome.text = match.home_name
            cell.labelAway.text = match.away_name
            
            if match.winning_team == "home" {
                cell.homeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.homeShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.homeShadow.alpha = 1
                cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if match.winning_team == "away" {
                cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.homeShadow.alpha = 0
                cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.awayShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.awayShadow.alpha = 1
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if match.winning_team == "draw" {
                cell.homeImage.transform = CGAffineTransform.identity
                cell.homeShadow.transform = CGAffineTransform.identity
                cell.homeShadow.alpha = 0
                cell.awayImage.transform = CGAffineTransform.identity
                cell.awayShadow.transform = CGAffineTransform.identity
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                
                cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
                cell.buttonDraw.backgroundColor = Colors.appBlue
                cell.buttonDraw.isEnabled = false
            } else {
                cell.homeImage.transform = CGAffineTransform.identity
                cell.homeShadow.transform = CGAffineTransform.identity
                cell.homeShadow.alpha = 0
                cell.awayImage.transform = CGAffineTransform.identity
                cell.awayShadow.transform = CGAffineTransform.identity
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 0
                cell.labelVS.alpha = 1
                
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
            }
            
            if match.confirmed != nil && match.confirmed! {
                cell.imageCheck.image = #imageLiteral(resourceName: "checked_white")
                cell.labelConfirm.textColor = Colors.white
                cell.labelConfirm.text = "CONFIRMED"
                cell.viewConfirm.backgroundColor = Colors.appGreen
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                cell.isUserInteractionEnabled = false
            } else if match.winning_team == nil || (match.winning_team?.isEmpty)! {
                cell.imageCheck.image = #imageLiteral(resourceName: "checked_blue")
                cell.labelVS.text = "VS"
                cell.labelVS.font = Fonts.textFont_Bold_XLarge
                cell.buttonDraw.alpha = 1
                cell.labelConfirm.textColor = Colors.appBlue
                cell.labelConfirm.text = "CONFIRM?"
                cell.viewConfirm.backgroundColor = Colors.white
                cell.viewConfirm.alpha = 0
                cell.isUserInteractionEnabled = true
            } else if match.winning_team != "draw" {
                cell.imageCheck.image = #imageLiteral(resourceName: "checked_blue")
                cell.labelConfirm.textColor = Colors.appBlue
                cell.labelConfirm.text = "CONFIRM?"
                cell.viewConfirm.backgroundColor = Colors.white
                cell.viewConfirm.alpha = 1
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
                cell.isUserInteractionEnabled = true
            }

            cell.labelTimeTitle.text = "TIME REMAINING"
            if let dateString = match.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let date = dateFormatter.date(from: dateString) {
                    cell.labelTime.setCountDownDate(targetDate: date as NSDate)
                    if !cell.labelTime.isCounting {
                        cell.labelTime.start()
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func exactScoreTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let exactScoreView = self.showView(name: Views.ExactScoreView) as? ExactScoreView {
                let match = Objects.matches[view.tag]
                if let homeFlag = match.home_flag, !homeFlag.isEmpty {
                    exactScoreView.homeImage.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
                }
                if let awayFlag = match.away_flag, !awayFlag.isEmpty {
                    exactScoreView.awayImage.kf.setImage(with: URL(string: Services.getMediaUrl() + awayFlag))
                }
                exactScoreView.labelHome.text = match.home_name
                exactScoreView.labelAway.text = match.away_name
                
                exactScoreView.textFieldHome.layer.cornerRadius = 10
                exactScoreView.textFieldAway.layer.cornerRadius = 10
                
                exactScoreView.textFieldHome.text = match.home_score
                exactScoreView.textFieldAway.text = match.away_score
                
                exactScoreView.buttonConfirm.tag = view.tag
                
                exactScoreView.setupNotificationCenter()
            }
        }
    }
    
    @objc func homeTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            Objects.matches[view.tag].winning_team = "home"
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? PredictionTableViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.homeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.homeShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.awayShadow.alpha = 0
                    cell.viewConfirm.alpha = 1
                    cell.labelVS.alpha = 0
                }, completion: { _ in
                    cell.homeShadow.alpha = 1
                })
                
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
            }
        }
    }
    
    @objc func awayTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            Objects.matches[view.tag].winning_team = "away"
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? PredictionTableViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.homeShadow.alpha = 0
                    cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.awayShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    cell.viewConfirm.alpha = 1
                    cell.labelVS.alpha = 0
                }, completion: { _ in
                    cell.awayShadow.alpha = 1
                })
                
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
            }
        }
    }
    
    @objc func drawTapped(sender: UIButton) {
        Objects.matches[sender.tag].winning_team = "draw"
        if let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? PredictionTableViewCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.homeImage.transform = CGAffineTransform.identity
                cell.homeShadow.transform = CGAffineTransform.identity
                cell.homeShadow.alpha = 0
                cell.awayImage.transform = CGAffineTransform.identity
                cell.awayShadow.transform = CGAffineTransform.identity
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            }, completion: { _ in })
            
            cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
            cell.buttonDraw.backgroundColor = Colors.appBlue
            cell.buttonDraw.isEnabled = false
        }
    }
    
    @objc func confirmTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if !UserDefaults.standard.bool(forKey: "didShowConfirmAlert") {
                self.showAlertView(title: "", message: "ARE YOU SURE YOU WANT TO CONFIRM THE PREDICTION? \nONCE CONFIRMED YOU CANNOT EDIT IT!!", cancelTitle: "EDIT", doneTitle: "CONFIRM")
                self.alertView.buttonDone.addTarget(self, action: #selector(confirmPrediction(sender:)), for: .touchUpInside)
                self.alertView.buttonDone.tag = view.tag
            } else {
                self.confirmPrediction(sender: view)
            }
        }
    }
    
    @objc func confirmPrediction(sender: AnyObject) {
        Objects.matches[sender.tag].confirmed = true
        if let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? PredictionTableViewCell {
            self.sendPrediction(index: sender.tag, cell: cell)

            // TODO
//            UserDefaults.standard.set(true, forKey: "didShowConfirmAlert")
//            UserDefaults.standard.synchronize()
        }
    }
    
    func sendPrediction(index: Int, cell: PredictionTableViewCell) {
        let match = Objects.matches[index]
        let prediction = Prediction()
        prediction.user_id = currentUser.id
        prediction.match_id = match.id
        prediction.status = "1"
        prediction.home_name = match.home_name
        prediction.home_flag = match.home_flag
        prediction.home_score = match.home_score
        prediction.away_name = match.away_name
        prediction.away_flag = match.away_flag
        prediction.away_score = match.away_score
        prediction.date = match.date
        prediction.selected_team = match.winning_team
        if prediction.selected_team == "home" {
            prediction.winning_team = match.home_id
        } else if prediction.selected_team == "away" {
            prediction.winning_team = match.away_id
        } else if prediction.selected_team == "draw" {
            prediction.winning_team = "0"
        }
        Objects.predictions.append(prediction)
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.sendPredictions(prediction: prediction)
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.imageCheck.image = #imageLiteral(resourceName: "checked_white")
                        cell.labelConfirm.textColor = Colors.white
                        cell.labelConfirm.text = "CONFIRMED"
                        cell.viewConfirm.backgroundColor = Colors.appGreen
                        cell.viewConfirm.alpha = 1
                        cell.labelVS.alpha = 0
                        cell.isUserInteractionEnabled = false
                    }, completion: { _ in })
                    
//                    Objects.matches.remove(at: index)
//                    self.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
                    
                    _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                        let contentOffset = self.tableView.contentOffset
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(contentOffset, animated: false)
                    })
                    
                    self.updateUserCoins()
                    self.labelCoins.text = currentUser.coins
                } else {
                    Objects.matches[index].confirmed = true
                    if let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? PredictionTableViewCell {
                        cell.imageCheck.image = #imageLiteral(resourceName: "checked_blue")
                        cell.labelConfirm.textColor = Colors.appBlue
                        cell.labelConfirm.text = "CONFIRM?"
                        cell.viewConfirm.backgroundColor = Colors.white
                        cell.viewConfirm.alpha = 1
                        cell.labelVS.alpha = 0
                        cell.isUserInteractionEnabled = true
                    }
                    
                    if let message = response?.message {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
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
