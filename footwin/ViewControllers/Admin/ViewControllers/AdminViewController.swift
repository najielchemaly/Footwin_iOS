//
//  AdminViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/21/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class AdminViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    class Option {
        var image: UIImage!
        var title: String!
        
        init(image: UIImage, title: String) {
            self.image = image
            self.title = title
        }
    }
    
    let options: [Option] = [
        Option.init(image: #imageLiteral(resourceName: "notification"), title: "Send Notification"),
        Option.init(image: #imageLiteral(resourceName: "match"), title: "Update Active Matches"),
        Option.init(image: #imageLiteral(resourceName: "result"), title: "Update Match Result")
    ]
    
    let refreshControl = UIRefreshControl()
    
    var users: [User] = [User]()
    var matches: [Match] = [Match]()
    var rounds: [Round] = [Round]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getGlobalData()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGlobalData() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getGlobalData()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let usersArray = json["users"] as? [NSDictionary] {
                            self.users = [User]()
                            let user = User()
                            user.avatar = "default_background.jpg"
                            user.username = "FOOTWIN"
                            self.users.append(user)
                            for userJson in usersArray {
                                let user = User.init(dictionary: userJson)
                                self.users.append(user!)
                            }
                        }
                        if let matchesArray = json["matches"] as? [NSDictionary] {
                            self.matches = [Match]()
                            for matchJson in matchesArray {
                                let match = Match.init(dictionary: matchJson)
                                self.matches.append(match!)
                            }
                        }
                        if let roundsArray = json["rounds"] as? [NSDictionary] {
                            self.rounds = [Round]()
                            for roundJson in roundsArray {
                                let round = Round.init(dictionary: roundJson)
                                self.rounds.append(round!)
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
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.AdminTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AdminTableViewCell)
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
        
        self.getGlobalData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let optionViewController = adminStoryboard.instantiateViewController(withIdentifier: StoryboardIds.OptionViewController) as? OptionViewController {
            switch indexPath.row {
            case 0:
                optionViewController.users = users
            case 1:
                optionViewController.rounds = rounds
            case 2:
                optionViewController.matches = matches
            default:
                break
            }
            
            optionViewController.navigationTitle = options[indexPath.row].title
            self.navigationController?.pushViewController(optionViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AdminTableViewCell) as? AdminTableViewCell {
            let option = options[indexPath.row]
            cell.imageIcon.layer.cornerRadius = cell.imageIcon.frame.size.width/2
            cell.imageIcon.image = option.image
            cell.labelTitle.text = option.title
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.logout()
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
