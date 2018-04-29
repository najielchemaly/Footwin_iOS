//
//  LeaderboardViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class LeaderboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelFullname: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    @IBOutlet weak var leaderboardUp: UIImageView!
    @IBOutlet weak var leaderboardMe: UIImageView!
    @IBOutlet weak var leaderboardDown: UIImageView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.getLeaderboard()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
//        if let avatar = currentUser.avatar, !avatar.isEmpty {
//            self.imageProfile.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
//        } else {
//            if let gender = currentUser.gender, gender.lowercased() == "male" {
//                self.imageProfile.image = #imageLiteral(resourceName: "avatar_male")
//            } else if let gender = currentUser.gender, gender.lowercased() == "female" {
//                self.imageProfile.image = #imageLiteral(resourceName: "avatar_female")
//            }
//        }
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
        
//        labelRank.text = currentUser.rank
//        labelFullname.text = currentUser.fullname
//        labelCoins.text = currentUser.winning_coins
        
        let leaderboardUpTap = UITapGestureRecognizer(target: self, action: #selector(leaderboardUpTapped))
        leaderboardUp.addGestureRecognizer(leaderboardUpTap)
        
        let leaderboardMeTap = UITapGestureRecognizer(target: self, action: #selector(leaderboardMeTapped))
        leaderboardMe.addGestureRecognizer(leaderboardMeTap)
        
        let leaderboardDownTap = UITapGestureRecognizer(target: self, action: #selector(leaderboardDownTapped))
        leaderboardDown.addGestureRecognizer(leaderboardDownTap)
    }
    
    @objc func leaderboardUpTapped() {
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .middle, animated: true)
    }
    
    @objc func leaderboardMeTapped() {
        let leaderboard = Objects.leaderboard.filter { $0.user_id == currentUser.id }.first
        if let me = leaderboard {
            if let myPostition = Objects.leaderboard.index(of: me) {
                tableView.scrollToRow(at: IndexPath.init(row: myPostition, section: 0), at: .middle, animated: true)
            }
        }
    }
    
    @objc func leaderboardDownTapped() {
        tableView.scrollToRow(at: IndexPath.init(row: Objects.leaderboard.count-1, section: 0), at: .middle, animated: true)
    }
    
    func getLeaderboard() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getLeaderboard()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["leaderboard"] as? [NSDictionary] {
                            Objects.leaderboard = [Leaderboard]()
                            for json in jsonArray {
                                let leaderboard = Leaderboard.init(dictionary: json)
                                Objects.leaderboard.append(leaderboard!)
//                                var leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "35000"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "34300"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "33600"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "32000"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "31900"
//                                leaderboard?.user_id = currentUser.id
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "30700"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "26400"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "25650"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "22800"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                leaderboard = Leaderboard.init(dictionary: json)
//                                leaderboard?.coins = "20200"
//                                leaderboard?.user_id = "0"
//                                Objects.leaderboard.append(leaderboard!)
//                                break
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
                
                if Objects.leaderboard.count == 0 {
                    self.addEmptyView(message: "IT SEEMS THERE ARE NO LEADERS YET! \nKEEP WINNING TO ACHIEVE THE FIRST RANK IN THE LEADERBOARD", frame: self.tableView.frame)
                } else {
                    self.labelRank.text = "1"
                    self.labelCoins.text = Objects.leaderboard[0].coins
                    self.labelFullname.text = Objects.leaderboard[0].fullname
                    if let avatar = Objects.leaderboard[0].avatar, !avatar.isEmpty {
                        self.imageProfile.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
                    }
//                    if let index = Objects.leaderboard.index(where: { $0.user_id == currentUser.id }) {
//                        self.labelRank.text = String(index.advanced(by: 1))
//                        self.labelCoins.text = Objects.leaderboard[index].coins
//                    }
                    
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.LeaderboardTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.LeaderboardTableViewCell)
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
        if Objects.leaderboard.count == 0 {
            self.showLoader()
        }
        
        self.getLeaderboard()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Objects.leaderboard.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.LeaderboardTableViewCell) as? LeaderboardTableViewCell {
            
            let leaderboard = Objects.leaderboard[indexPath.row]
            if let avatar = leaderboard.avatar, !avatar.isEmpty {
                cell.imageProfile.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
            }
            cell.imageProfile.layer.cornerRadius = cell.imageProfile.frame.size.width/2
            cell.imageProfile.layer.borderColor = Colors.lightGray.cgColor
            cell.imageProfile.layer.borderWidth = 1
            
            leaderboard.rank = String(indexPath.row+1)
            cell.labelRank.text = leaderboard.rank
            cell.labelName.text = leaderboard.fullname
            cell.labelCoins.text = leaderboard.coins
            
            return cell
        }
        
        return UITableViewCell()
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
