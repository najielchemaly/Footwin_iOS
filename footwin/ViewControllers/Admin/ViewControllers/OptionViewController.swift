//
//  OptionViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/21/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class OptionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackViewRound: UIStackView!
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var buttonType: UIButton!
    @IBOutlet weak var buttonMatch: UIButton!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var buttonMatchHeightConstraint: NSLayoutConstraint!
    
    var users: [User]!
    var matches: [Match]!
    var rounds: [Round]!
    
    var pickerView: UIPickerView!
    var selectedRound: String!
    var navigationTitle: String!
    var selectedType: String!
    var selectedMatch: String!
    var selectedUserId: String!
    
    let textViewPlaceholder = "ENTER MESSAGE"
    let matchPlaceholder = "SELECT MATCH"
    let typePlaceholder = "SELECT TYPE"
    
    class NotificationType {
        var id: String!
        var title: String!
        
        init(id: String?, title: String?) {
            self.id = id
            self.title = title
        }
    }
    
    let notificationTypes = [
        NotificationType.init(id: nil, title: ""),
        NotificationType.init(id: "1", title: "get_coins"),
        NotificationType.init(id: "2", title: "prediction_result"),
        NotificationType.init(id: "3", title: "message")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        if rounds == nil {
            tableView.alpha = 1
            stackViewRound.alpha = 0
        } else {
            tableView.alpha = 0
            stackViewRound.alpha = 1
        }
        
        textViewMessage.delegate = self
        textViewMessage.text = textViewPlaceholder
        textViewMessage.textColor = .lightGray
        
        buttonMatchHeightConstraint.constant = 0
        buttonMatch.setTitle(nil, for: .normal)
        
        buttonType.customizeBorder(color: .darkGray)
        buttonMatch.customizeBorder(color: .darkGray)
        buttonRound.customizeBorder(color: .darkGray)
        textViewMessage.customizeBorder(color: .darkGray)
        
        textFieldTitle.addBottomBorderWithColor(color: .darkGray, width: 1)
        
        self.title = navigationTitle
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.backgroundColor = Colors.white
        self.pickerView.frame.size.width = self.view.frame.size.width
        self.pickerView.frame.origin.y = self.view.frame.size.height
        self.view.addSubview(self.pickerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return rounds.count
        } else if pickerView.tag == 2 {
            return notificationTypes.count
        } else if pickerView.tag == 3 {
            return 0 // matches
        }
        
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1, let rounds = rounds {
            return rounds[row].title
        } else if pickerView.tag == 2 {
            return notificationTypes[row].title
        } else if pickerView.tag == 3 {
            return ""
        }
        
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.buttonRound.setTitle(rounds[row].title, for: .normal)
            self.selectedRound = rounds[row].id
        } else if pickerView.tag == 2 {
            self.buttonType.setTitle(notificationTypes[row].title, for: .normal)
            self.selectedType = notificationTypes[row].id
            
            if self.selectedType == "2" {
                buttonMatchHeightConstraint.constant = 40
                buttonMatch.setTitle(matchPlaceholder, for: .normal)
            } else {
                buttonMatchHeightConstraint.constant = 0
                buttonMatch.setTitle(nil, for: .normal)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else if pickerView.tag == 3 {
            
        }
        
        self.hidePicker()
    }
    
    @objc func hidePicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y = self.view.frame.size.height
        })
    }
    
    func showPicker(tag: Int = 0) {
        self.pickerView.tag = tag
        self.pickerView.reloadAllComponents()
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y -= self.pickerView.frame.size.height
        })
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.AdminTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AdminTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.MatchTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MatchTableViewCell)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users.count
        } else if matches != nil {
            return matches.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if users != nil {
            return 80
        } else if matches != nil {
            return 220
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if users != nil {
            self.initializeViews()
            
            selectedUserId = users[indexPath.row].id
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewNotification.alpha = 1
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if users != nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AdminTableViewCell) as? AdminTableViewCell {
                let user = users[indexPath.row]
                if let avatar = user.avatar {
                    cell.imageIcon.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
                }
                cell.imageIcon.layer.cornerRadius = cell.imageIcon.frame.size.width/2
                cell.labelTitle.text = user.username
                
                return cell
            }
        } else if matches != nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MatchTableViewCell) as? MatchTableViewCell {
                cell.selectionStyle = .none
                cell.tag = indexPath.row
                
                let exactScoreTap = UITapGestureRecognizer(target: self, action: #selector(exactScoreTapped(sender:)))
                cell.viewExactScore.addGestureRecognizer(exactScoreTap)
                cell.viewExactScore.tag = indexPath.row
                
                cell.viewSubmit.layer.cornerRadius = cell.viewSubmit.frame.size.width/2
                
                let homeTap = UITapGestureRecognizer(target: self, action: #selector(homeTapped(sender:)))
                cell.homeImage.addGestureRecognizer(homeTap)
                cell.homeImage.tag = indexPath.row
                
                let awayTap = UITapGestureRecognizer(target: self, action: #selector(awayTapped(sender:)))
                cell.awayImage.addGestureRecognizer(awayTap)
                cell.awayImage.tag = indexPath.row
                
                let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped(sender:)))
                cell.viewSubmit.addGestureRecognizer(confirmTap)
                cell.viewSubmit.tag = indexPath.row
                
                cell.buttonDraw.customizeBorder(color: Colors.white)
                cell.buttonDraw.addTarget(self, action: #selector(drawTapped(sender:)), for: .touchUpInside)
                cell.buttonDraw.tag = indexPath.row
                
                let match = matches[indexPath.row]
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
                    cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                } else if match.winning_team == "away" {
                    cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                } else if match.winning_team == "draw" {
                    cell.homeImage.transform = CGAffineTransform.identity
                    cell.awayImage.transform = CGAffineTransform.identity
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                    
                    cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
                    cell.buttonDraw.backgroundColor = Colors.appBlue
                    cell.buttonDraw.isEnabled = false
                } else {
                    cell.homeImage.transform = CGAffineTransform.identity
                    cell.awayImage.transform = CGAffineTransform.identity
                    cell.viewSubmit.alpha = 0
                    cell.labelVS.alpha = 1
                    
                    cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                    cell.buttonDraw.backgroundColor = .clear
                    cell.buttonDraw.isEnabled = true
                }
                
                if match.confirmed != nil && match.confirmed! {
                    cell.imageCheck.image = #imageLiteral(resourceName: "checked_white")
                    cell.labelSubmit.textColor = Colors.white
                    cell.labelSubmit.text = "CONFIRMED"
                    cell.viewSubmit.backgroundColor = Colors.appGreen
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                    cell.isUserInteractionEnabled = false
                } else if match.winning_team == nil || (match.winning_team?.isEmpty)! {
                    cell.imageCheck.image = #imageLiteral(resourceName: "checked_blue")
                    cell.labelVS.text = "VS"
                    cell.labelVS.font = Fonts.textFont_Bold_XLarge
                    cell.buttonDraw.alpha = 1
                    cell.labelSubmit.textColor = Colors.appBlue
                    cell.labelSubmit.text = "CONFIRM?"
                    cell.viewSubmit.backgroundColor = Colors.white
                    cell.viewSubmit.alpha = 0
                    cell.isUserInteractionEnabled = true
                } else if match.winning_team != "draw" {
                    cell.imageCheck.image = #imageLiteral(resourceName: "checked_blue")
                    cell.labelSubmit.textColor = Colors.appBlue
                    cell.labelSubmit.text = "CONFIRM?"
                    cell.viewSubmit.backgroundColor = Colors.white
                    cell.viewSubmit.alpha = 1
                    cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                    cell.buttonDraw.backgroundColor = .clear
                    cell.buttonDraw.isEnabled = true
                    cell.isUserInteractionEnabled = true
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func exactScoreTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let exactScoreView = self.showView(name: Views.ExactScoreView) as? ExactScoreView {
                let match = matches[view.tag]
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
            matches[view.tag].winning_team = "home"
            if matches[view.tag].home_score == matches[view.tag].away_score {
                matches[view.tag].home_score = nil
                matches[view.tag].away_score = nil
            }
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? MatchTableViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.homeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.awayImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                }, completion: { _ in })
                
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
            }
        }
    }
    
    @objc func awayTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            matches[view.tag].winning_team = "away"
            if matches[view.tag].home_score == matches[view.tag].away_score {
                matches[view.tag].home_score = nil
                matches[view.tag].away_score = nil
            }
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? MatchTableViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.homeImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    cell.awayImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                }, completion: { _ in })
                
                cell.buttonDraw.layer.borderColor = Colors.white.cgColor
                cell.buttonDraw.backgroundColor = .clear
                cell.buttonDraw.isEnabled = true
            }
        }
    }
    
    @objc func drawTapped(sender: UIButton) {
        matches[sender.tag].winning_team = "draw"
        matches[sender.tag].home_score = nil
        matches[sender.tag].away_score = nil
        if let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? MatchTableViewCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.homeImage.transform = CGAffineTransform.identity
                cell.awayImage.transform = CGAffineTransform.identity
                cell.viewSubmit.alpha = 1
                cell.labelVS.alpha = 0
            }, completion: { _ in })
            
            cell.buttonDraw.layer.borderColor = Colors.appBlue.cgColor
            cell.buttonDraw.backgroundColor = Colors.appBlue
            cell.buttonDraw.isEnabled = false
        }
    }
    
    @objc func confirmTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? MatchTableViewCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.imageCheck.image = #imageLiteral(resourceName: "checked_white")
                    cell.labelSubmit.textColor = Colors.white
                    cell.labelSubmit.text = "SUBMITTED"
                    cell.viewSubmit.backgroundColor = Colors.appGreen
                    cell.viewSubmit.alpha = 1
                    cell.labelVS.alpha = 0
                    cell.isUserInteractionEnabled = false
                }, completion: { _ in
                    let match = self.matches[view.tag]
                    self.showLoader()
                    
                    DispatchQueue.global(qos: .background).async {
                        let response = appDelegate.services.updateMatchResult(match_id: match.id!, winning_team: match.winning_team!, home_score: match.home_score!, away_score: match.away_score!)
                        
                        DispatchQueue.main.async {
                            if response?.status == ResponseStatus.SUCCESS.rawValue {
                                self.showAlertView(message: "MATCH RESULT WAS UPDATED SUCCESSFULLY")
                            } else {
                                if let message = response?.message {
                                    self.showAlertView(message: message)
                                }
                            }
                            
                            self.hideLoader()
                        }
                    }
                })
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
        }
    }

    @IBAction func buttonRoundTapped(_ sender: Any) {
        self.showPicker(tag: 1)
    }
    
    @IBAction func buttonActivateTapped(_ sender: Any) {
        if selectedRound != nil {
            self.showLoader()
            
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.updateActiveMatches(round: self.selectedRound)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        self.showAlertView(message: "MATCHES HAS BEEN UPDATED SUCCESSFULLY")
                    } else {
                        if let message = response?.message {
                            self.showAlertView(message: message)
                        }
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: "SELECT WHICH ROUND YOU NEED TO ACTIVATE TO PROCEED")
        }
    }
    
    @IBAction func buttonTypeTapped(_ sender: Any) {
        self.showPicker(tag: 2)
    }
    
    @IBAction func buttonMatchTapped(_ sender: Any) {
        self.showPicker(tag: 3)
    }
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let title = textFieldTitle.text
            let message = textViewMessage.text
            
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.sendNotification(user_id: self.selectedUserId ?? "", title: title!, message: message!, type: self.selectedType ?? "", match_id: self.selectedMatch ?? "")
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        self.showAlertView(message: "NOTIFICATION WAS SENT SUCCESSFULLY")
                    } else {
                        if let message = response?.message {
                            self.showAlertView(message: message)
                        }
                    }
                    
                    self.hideLoader()
                    self.resetFields()
                }
            }
        } else {
            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        selectedUserId = nil
        UIView.animate(withDuration: 0.3, animations: {
            self.viewNotification.alpha = 0
        }, completion: { success in
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.alpha = 1
            })
        })
    }
    
    func resetFields() {
        selectedType = nil
        buttonType.setTitle(typePlaceholder, for: .normal)
        selectedMatch = nil
        buttonMatchHeightConstraint.constant = 0
        buttonMatch.setTitle(nil, for: .normal)
        textFieldTitle.text = nil
        textViewMessage.text = textViewPlaceholder
        textViewMessage.textColor = .lightGray
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if selectedType == "2" && selectedMatch == nil {
            errorMessage = "YOU MUST SELECT A SPECIFIC MATCH TO PROCEED"
            return false
        }
        if textFieldTitle.isEmpty() {
            errorMessage = "TITLE FIELD CANNOT BE EMPTY"
            return false
        }
        if textViewMessage.isEmpty() {
            errorMessage = "MESSAGE FIELD CANNOT BE EMPTY"
            return false
        }
        
        return true
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
