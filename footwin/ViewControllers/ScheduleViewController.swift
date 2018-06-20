//
//  ScheduleViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 6/11/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ScheduleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var pickerView: UIPickerView!
    var currentDate: String!
    
    var filteredMatches = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getScheduleMatches()
        self.initializeViews()
        self.setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initializeViews() {
        self.buttonRound.isEnabled(enable: false)
    }
    
    func getScheduleMatches() {
        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getScheduleMatches()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["schedule_matches"] as? [NSDictionary] {
                            Objects.scheduleMatches = [Match]()
                            for json in jsonArray {
                                let match = Match.init(dictionary: json)
                                Objects.scheduleMatches.append(match!)
                            }
                            self.filteredMatches = Objects.scheduleMatches
                        }
                        if let jsonArray = json["rounds"] as? [NSDictionary] {
                            Objects.rounds = [Round]()
                            Objects.rounds.append(Round.init(id: "-1", title: "All matches"))
                            for json in jsonArray {
                                let round = Round.init(dictionary: json)
                                Objects.rounds.append(round!)
                            }
                        }
                        if let currentDate = json["current_date"] as? String {
                            self.currentDate = currentDate
                        }
                    }
                } else {
                    if let message = response?.message {
                        self.showAlertView(message: message)
                    }
                }
                
                self.hideLoader()
                self.refreshControl.endRefreshing()
                
                if Objects.rounds.count > 0 {
                    self.buttonRound.isEnabled(enable: true)
                    self.setupPickerView()
                }
                
                if Objects.scheduleMatches.count == 0 {
                    self.addEmptyView(message: "SOMETHING WENT WRONG, TRY TO REFRESH THE PAGE", frame: self.tableView.frame)
                } else {
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.ScheduleTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.ScheduleTableViewCell)
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
        if Objects.matches.count == 0 || fromNotification {
            self.showLoader()
        }
        
        self.getScheduleMatches()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMatches.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.ScheduleTableViewCell) as? ScheduleTableViewCell {
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            let match = self.filteredMatches[indexPath.row]
            if let homeFlag = match.home_flag, !homeFlag.isEmpty {
                cell.homeImage.kf.setImage(with: URL(string: Services.getMediaUrl() + homeFlag))
            }
            if let awayFlag = match.away_flag, !awayFlag.isEmpty {
                cell.awayImage.kf.setImage(with: URL(string: Services.getMediaUrl() + awayFlag))
            }
            cell.labelHome.text = match.home_name
            cell.labelAway.text = match.away_name
            
            cell.labelTimeTitle.text = "TIME REMAINING"
            if let dateString = match.date, let currentDateString = currentDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: dateString+":00"), let currentDate = dateFormatter.date(from: currentDateString) {
                    cell.labelTime.setCountDownDate(fromDate: currentDate as NSDate, targetDate: date as NSDate)
                    if !cell.labelTime.isCounting {
                        cell.labelTime.start()
                    }
                    
                    dateFormatter.dateFormat = "EEEE, MMMM dd"
                    let matchDateString = dateFormatter.string(from: date)
                    dateFormatter.dateFormat = "HH:mm"
                    let matchTimeString = dateFormatter.string(from: date)
                    cell.labelDate.text = matchDateString + "\n" + matchTimeString
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.backgroundColor = Colors.white
        self.pickerView.frame.size.width = self.view.frame.size.width
        self.pickerView.frame.origin.y = self.view.frame.size.height
        self.view.addSubview(self.pickerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideRoundPicker))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Objects.rounds.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let title = Objects.rounds[row].title {
            return title
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let title = Objects.rounds[row].title, let id = Objects.rounds[row].id {
            self.labelRound.text = title
            if id == "-1" {
                self.filteredMatches = Objects.scheduleMatches
            } else {
                self.filteredMatches = Objects.scheduleMatches.filter { $0.round == id }
            }
            
            if self.filteredMatches.count == 0 {
                if let round = self.labelRound.text {
                    self.addEmptyView(message: "MATCHES FOR " + round + " ARE NOT AVAILABLE YET", frame: self.tableView.frame)
                }
            } else {
                self.tableView.reloadData()
                self.removeEmptyView()
            }
            
            self.tableView.reloadData()
        }
        
        self.hideRoundPicker()
    }
    
    @objc func hideRoundPicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y = self.view.frame.size.height
        })
    }
    
    func showRoundPicker() {
        self.removeEmptyView()
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y -= self.pickerView.frame.size.height
        })
    }
    
    @IBAction func buttonRoundTapped(_ sender: Any) {
        self.showRoundPicker()
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
