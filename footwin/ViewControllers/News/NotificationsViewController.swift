//
//  NotificationsViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonClose: UIButton!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getNotifications()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNotifications() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getNotifications()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["notifications"] as? [NSDictionary] {
                            Objects.notifications = [Notification]()
                            for json in jsonArray {
                                let notification = Notification.init(dictionary: json)
                                Objects.notifications.append(notification!)
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
                
                if Objects.notifications.count == 0 {
                    self.addEmptyView(message: "YOU DO NOT HAVE NOTIFICATIONS YET!!", frame: self.tableView.frame)
                } else {
                    self.updateNotificationBadge()
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func updateNotificationBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.removeObject(forKey: "notificationNumber")
        UserDefaults.standard.synchronize()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.NotificationsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.NotificationsTableViewCell)
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
        if Objects.notifications.count == 0 {
            self.showLoader()
        }
        
        self.getNotifications()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Objects.notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let notification = Objects.notifications[indexPath.row]
        var tableRowHeight: CGFloat = 0
        if notification.type?.lowercased() == "get_coins" {
            tableRowHeight = 75
        } else if notification.type?.lowercased() == "prediction_result" {
            tableRowHeight = 150
        } else {
            tableRowHeight = 45
        }
        
        if let estimatedHeight = notification.row_height {
            if indexPath.row == 0 {
                return tableRowHeight + (estimatedHeight < tableRowHeight ? tableRowHeight : estimatedHeight)
            }
            
            return tableRowHeight + (estimatedHeight < tableRowHeight ? tableRowHeight : estimatedHeight)
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.NotificationsTableViewCell) as? NotificationsTableViewCell {
            cell.selectionStyle = .none
            
            let notification = Objects.notifications[indexPath.row]
            
            cell.labelDescription.text = notification.desc
            
            var height: Int = 0
            if let descriptionHeight = notification.desc?.height(width: cell.labelDescription.frame.size.width, font: cell.labelDescription.font!) {
                height += Int(descriptionHeight)
            }
            notification.row_height = CGFloat(height)
            
            if notification.is_read != nil && notification.is_read! {
                cell.imageNew.isHidden = true
            } else {
                cell.imageNew.isHidden = false
                
                DispatchQueue.global(qos: .background).async {
                    if let id = notification.id, notification.is_read_updated == nil {
                        appDelegate.services.updateNotification(id: id)
                        
                        Objects.notifications[indexPath.row].is_read_updated = true
                    }
                }
            }
            
            if notification.type == "prediction_result" {
                if let homeFlag = notification.home_flag, !homeFlag.isEmpty {
                    cell.imageHome.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
                }
                if let homeName = notification.home_name {
                    cell.labelHome.text = homeName
                }
                if let awayFlag = notification.away_flag, !awayFlag.isEmpty {
                    cell.imageAway.kf.setImage(with: URL(string: Services.getMediaUrl() + awayFlag))
                }
                if let awayName = notification.away_name {
                    cell.labelAway.text = awayName
                }
                if let homeScore = notification.home_score, let awayScore = notification.away_score {
                    cell.labelResult.text = homeScore + " - " + awayScore
                }
                
                cell.buttonGetCoins.alpha = 0
                cell.viewMatchResult.alpha = 1
            } else if notification.type == "get_coins" {           
                cell.buttonGetCoins.alpha = 1
                cell.viewMatchResult.alpha = 0
            } else {
                cell.buttonGetCoins.alpha = 0
                cell.viewMatchResult.alpha = 0
            }
            
            if let dateString = notification.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = formatter.date(from: dateString) {
                    cell.labelDate.text = timeAgoSince(date)
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
