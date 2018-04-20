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
                    }
                }
                
                self.hideLoader()
                self.refreshControl.endRefreshing()
                
                if Objects.predictions.count == 0 {
                    self.addEmptyView(message: "Something went wrong, try to refresh the page", frame: self.tableView.frame)
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
        return 185
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
            cell.labelHomeScore.text = prediction.home_score
            cell.labelAwayScore.text = prediction.away_score
            
            if prediction.selected_team == "home" {
                cell.homeImage.alpha = 1
                cell.homeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.homeShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.homeShadow.alpha = 1
                cell.awayImage.alpha = 0.5
                cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                cell.buttonDraw.alpha = 0.5
            } else if prediction.selected_team == "away" {
                cell.homeImage.alpha = 0.5
                cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                cell.homeShadow.alpha = 0
                cell.awayImage.alpha = 1
                cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                cell.awayShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.awayShadow.alpha = 1
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                cell.buttonDraw.alpha = 0.5
            } else if prediction.selected_team == "draw" {
                cell.homeImage.alpha = 1
                cell.homeImage.transform = CGAffineTransform.identity
                cell.homeShadow.transform = CGAffineTransform.identity
                cell.homeShadow.alpha = 0
                cell.homeImage.alpha = 1
                cell.awayImage.transform = CGAffineTransform.identity
                cell.awayShadow.transform = CGAffineTransform.identity
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
                cell.buttonDraw.alpha = 1
            }
            
            cell.labelTitle.text = prediction.title
            cell.labelDescription.text = prediction.desc
            
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
