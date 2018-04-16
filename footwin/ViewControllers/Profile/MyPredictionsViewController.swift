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
            
            cell.viewConfirm.layer.cornerRadius = cell.viewConfirm.frame.size.width/2
            cell.buttonDraw.customizeBorder(color: Colors.white)
            
            let prediction = Objects.predictions[indexPath.row]
            if let homeFlag = prediction.home_flag {
                //                cell.homeImage.kf.setImage(with: URL(string: homeFlag))
            }
            if let awayFlag = prediction.away_flag {
                //                cell.awayImage.kf.setImage(with: URL(string: awayFlag))
            }
            cell.labelHome.text = prediction.home_name
            cell.labelAway.text = prediction.away_name
            
            cell.buttonDraw.backgroundColor = .clear
            cell.buttonDraw.isEnabled = true
            
            if prediction.selected_team == "home" {
                cell.homeWidthConstraint.constant = 100
                cell.homeShadowWidthConstraint.constant = 120
                cell.homeShadow.alpha = 1
                cell.awayWidthConstraint.constant = 80
                cell.awayShadowWidthConstraint.constant = 110
                cell.awayShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if prediction.selected_team == "away" {
                cell.awayWidthConstraint.constant = 100
                cell.awayShadowWidthConstraint.constant = 120
                cell.awayShadow.alpha = 1
                cell.homeWidthConstraint.constant = 80
                cell.homeShadowWidthConstraint.constant = 110
                cell.homeShadow.alpha = 0
                cell.viewConfirm.alpha = 1
                cell.labelVS.alpha = 0
            } else if prediction.selected_team == "draw" {
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
            
//            if match.confirmed != nil && match.confirmed! {
//                cell.viewConfirm.backgroundColor = Colors.appGreen
//                cell.viewConfirm.alpha = 1
//                cell.labelVS.alpha = 0
//                cell.isUserInteractionEnabled = false
//                cell.contentView.isEnabled(enable: false)
//            } else {
//                cell.labelVS.text = "VS"
//                cell.labelVS.font = Fonts.textFont_Bold_XLarge
//                cell.buttonDraw.alpha = 1
//                cell.viewConfirm.backgroundColor = Colors.white
//                cell.isUserInteractionEnabled = true
//                cell.contentView.isEnabled(enable: true)
//            }
            
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
