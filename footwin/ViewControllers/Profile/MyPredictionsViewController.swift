//
//  MyPredictionsViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class MyPredictionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.getPredictions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func getPredictions() {
        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getPredictions()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["predictions"] as? [NSDictionary] {
                            Objects.predictions = [Prediction]()
                            for json in jsonArray {
                                let prediction = Prediction.init(dictionary: json)
                                Objects.predictions.append(prediction!)
                            }
                        }
                    }
                } else {
                    if let message = response?.message {
                        self.showAlertView(message: message)
                    } else {
                        self.addEmptyView(message: "SOMETHING WENT WRONG, TRY TO REFRESH THE PAGE!", frame: self.tableView.frame)
                    }
                }
                
                self.hideLoader()
                self.refreshControl.endRefreshing()
                
                if Objects.predictions.count == 0 {
                    if isReview {
                        self.addEmptyView(message: "YOU DO NOT HAVE PREDICTIONS YET!", frame: self.tableView.frame)
                    } else {
                        self.addEmptyView(message: "NOTHING TO SHOW YET!\nSTART WINNING PREDICTIONS, HIT THE FIRST PLACE IN THE LEADERBOARD AND WIN A SPECIAL TRIP TO YOUR FAVORITE TEAM'S COUNTRY!", frame: self.tableView.frame)
                    }
                } else {
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.MyPredictionTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MyPredictionTableViewCell)
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
        if Objects.predictions.count == 0 {
            self.showLoader()
        }
        
        self.getPredictions()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Objects.predictions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MyPredictionTableViewCell) as? MyPredictionTableViewCell {
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            
            cell.viewConfirm.layer.cornerRadius = cell.viewConfirm.frame.size.width/2
            cell.buttonDraw.customizeBorder(color: Colors.white)
            
            let prediction = Objects.predictions[indexPath.row]
            if let homeFlag = prediction.home_flag, !homeFlag.isEmpty {
                cell.homeImage.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
            }
            if let awayFlag = prediction.away_flag, !awayFlag.isEmpty {
                cell.awayImage.kf.setImage(with: URL(string: Services.getMediaUrl() + awayFlag))
            }
            cell.labelHome.text = prediction.home_name
            cell.labelAway.text = prediction.away_name
            cell.labelHomeScore.text = prediction.home_score == "-1" ? "" : prediction.home_score
            cell.labelAwayScore.text = prediction.away_score == "-1" ? "" : prediction.away_score
            
            if prediction.winning_team == prediction.home_id {
                cell.homeImage.alpha = 1
                cell.homeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.homeShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.homeShadow.alpha = 1
                cell.awayImage.alpha = 0.5
                cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.alpha = 0.5
            } else if prediction.winning_team == prediction.away_id {
                cell.homeImage.alpha = 0.5
                cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.homeShadow.alpha = 0
                cell.awayImage.alpha = 1
                cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.awayShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.awayShadow.alpha = 1
                cell.viewConfirm.alpha = 1
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.alpha = 0.5
            } else if prediction.winning_team == "0" {
                cell.homeImage.alpha = 0.5
                cell.homeImage.transform = CGAffineTransform.identity
                cell.homeShadow.transform = CGAffineTransform.identity
                cell.homeShadow.alpha = 0
                cell.awayImage.alpha = 0.5
                cell.awayImage.transform = CGAffineTransform.identity
                cell.awayShadow.transform = CGAffineTransform.identity
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
                cell.buttonDraw.backgroundColor = Colors.appBlue
                cell.buttonDraw.alpha = 1
            }
            
            if prediction.home_score == "-1" && prediction.away_score == "-1" {
                cell.labelVS.text = "VS"
            }
            
            cell.labelTitle.text = prediction.title
            if let status = prediction.status {
                switch status {
                case "1":
                    cell.viewConfirmWidthConstraint.constant = 70
                    cell.topBarImageView.image = #imageLiteral(resourceName: "time_remaining_background")
                    if let dateString = prediction.date {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        if let date = dateFormatter.date(from: dateString) {
                            cell.labelDescription.setCountDownDate(targetDate: date as NSDate)
                            if !cell.labelDescription.isCounting {
                                cell.labelDescription.start()
                            }
                        }
                    }
                case "2", "3":
                    cell.viewWinningCoins.alpha = 1
                    cell.viewConfirmWidthConstraint.constant = 0
                    cell.topBarImageView.image = #imageLiteral(resourceName: "myprediction_top_green")
                    cell.labelDescription.text = prediction.desc
                    if let winning_coins = prediction.winning_coins {
                        cell.labelWinningCoins.text = "+" + winning_coins
                    }
                case "4":
                    cell.topBarImageView.image = #imageLiteral(resourceName: "myprediction_top_red")
                    cell.labelDescription.text = prediction.desc
                default:
                    break;
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func buttonCloseTapped(_ sender: Any) {
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
