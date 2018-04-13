//
//  SignupStep1ViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import Planet

class SignupViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, ImagePickerDelegate {
   
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelStep: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewTeam: UICollectionView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonBackWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var scrollViewInfo: UIScrollView!
    @IBOutlet weak var viewFullname: UIView!
    @IBOutlet weak var textFieldFullname: UITextField!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var labelDialingCode: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var buttonGender: UIButton!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var buttonCountry: UIButton!
    @IBOutlet weak var viewTakePicture: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonTakePicture: UIButton!
    @IBOutlet weak var buttonCamera: UIButton!
    
    var pickerView: UIPickerView!
    var tempUser: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupCollectionView()
        self.setupPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.viewFullname.customizeBorder(color: Colors.white)
        self.viewUsername.customizeBorder(color: Colors.white)
        self.viewEmail.customizeBorder(color: Colors.white)
        self.viewPassword.customizeBorder(color: Colors.white)
        self.viewPhone.customizeBorder(color: Colors.white)
        self.viewGender.customizeBorder(color: Colors.white)
        self.viewCountry.customizeBorder(color: Colors.white)
        
        if isReview {
            self.textFieldPhone.placeholder = "(Optional)"
            self.buttonGender.setTitle("(Optional)", for: .normal)
        }
    }
    
    func setupCollectionView() {
        self.collectionViewTeam.register(UINib.init(nibName: CellIds.TeamCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: "TeamCollectionViewCell")
        
        self.collectionViewTeam.delegate = self
        self.collectionViewTeam.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Objects.teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        Objects.teams.forEach({ $0.is_selected = false })
        tempUser.favorite_team = nil
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell {
            if cell.selectedTeamOverlay.alpha == 0 {
                Objects.teams[indexPath.row].is_selected = true
                
                UIView.animate(withDuration: 0.1, animations: {
                    cell.selectedTeamOverlay.alpha = 1
                    cell.selectedCheckmark.alpha = 1
                }, completion: { success in
                    collectionView.reloadData()
                })
                
                if let teamId = Objects.teams[indexPath.row].id {
                    tempUser.favorite_team = teamId
                }
            } else {
                Objects.teams[indexPath.row].is_selected = false
                
                UIView.animate(withDuration: 0.1, animations: {
                    cell.selectedTeamOverlay.alpha = 0
                    cell.selectedCheckmark.alpha = 0
                }, completion: { success in
                    collectionView.reloadData()
                })
            }
        }
    }
    
    let itemSpacing: CGFloat = 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width/2)-itemSpacing
        let itemHeight = (collectionView.bounds.width/2)+itemSpacing
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.TeamCollectionViewCell, for: indexPath) as? TeamCollectionViewCell {
            
            let team = Objects.teams[indexPath.row]
            cell.labelTeamName.text = team.name
            
            if let flag = team.flag, !flag.isEmpty {
                cell.imageTeam.kf.setImage(with: URL(string: flag))
            }
            
            if team.is_selected == nil || !(team.is_selected)! {
                cell.selectedCheckmark.alpha = 0
                cell.selectedTeamOverlay.alpha = 0
            } else {
                cell.selectedCheckmark.alpha = 1
                cell.selectedTeamOverlay.alpha = 1
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.backgroundColor = Colors.white
        self.pickerView.frame.size.width = self.view.frame.size.width
        self.pickerView.frame.origin.y = self.view.frame.size.height
        self.view.addSubview(self.pickerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideGenderPicker))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Objects.gender.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Objects.gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.buttonGender.setTitle(Objects.gender[row], for: .normal)
        
        self.hideGenderPicker()
    }
    
    @objc func hideGenderPicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y = self.view.frame.size.height
        })
    }
    
    func showGenderPicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.frame.origin.y -= self.pickerView.frame.size.height
        })
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        
        if textFieldFullname.text == nil || textFieldFullname.text == "" {
            errorMessage = "FULLNAME FIELD CANNOT BE EMPTY"
            return false
        }
        if textFieldUsername.text == nil || textFieldUsername.text == "" {
            errorMessage = "USERNAME FIELD CANNOT BE EMPTY"
            return false
        }
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = "EMAIL FIELD CANNOT BE EMPTY"
            return false
        }
        if textFieldPassword.text == nil || textFieldPassword.text == "" {
            errorMessage = "PASSWORD FIELD CANNOT BE EMPTY"
            return false
        }
        if buttonCountry.titleLabel?.text == nil || buttonCountry.titleLabel?.text == "" {
            errorMessage = "COUNTRY FIELD CANNOT BE EMPTY"
            return false
        }
        if !isReview && (textFieldPhone.text == nil || textFieldPhone.text == "") {
            errorMessage = "PHONE NUMBER FIELD CANNOT BE EMPTY"
            return false
        }
        if !isReview && (buttonGender.titleLabel?.text == nil || buttonGender.titleLabel?.text == "") {
            errorMessage = "GENDER FIELD CANNOT BE EMPTY"
            return false
        }
        
        return true
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            tempUser.image = image
            
            self.viewTakePicture.alpha = 0
        }
    }
    
    func didCancelPickingMedia() {
        
    }
    
    func fillUserInfo() {
        tempUser.fullname = textFieldFullname.text
        tempUser.username = textFieldUsername.text
        tempUser.email = textFieldEmail.text
        tempUser.password = textFieldPassword.text
        tempUser.country = buttonCountry.titleLabel?.text
        tempUser.phone = labelDialingCode.text! + textFieldPhone.text!
        tempUser.gender = buttonGender.titleLabel?.text
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonContinueTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case 1:
                if tempUser.favorite_team != nil {
                    labelStep.text = "STEP 2"
                    labelTitle.text = "TELL US MORE ABOUT YOU"
                    buttonBackWidthContraint.constant = 100
                    collectionViewTeam.alpha = 0
                    viewTakePicture.alpha = 0
                    scrollViewInfo.alpha = 1
                    button.tag = 2
                } else {
                    self.showAlertView(message: "CHOOSE YOUR FAVORITE TEAM TO PROCEED :D")
                }
                break
            case 2:
                if isValidData() {
                    labelStep.text = "STEP 3"
                    labelTitle.text = "SET YOUR PROFILE PICTURE"
                    buttonContinue.setTitle("LET'S START", for: .normal)
                    collectionViewTeam.alpha = 0
                    viewTakePicture.alpha = 1
                    scrollViewInfo.alpha = 0
                    button.tag = 3
                } else {
                    self.showAlertView(message: errorMessage)
                }
                break
            case 3:
                // TODO change condition
                if tempUser.image == nil {
                    self.fillUserInfo()
                    self.showLoader()
                    
                    DispatchQueue.global(qos: .background).async {
                        let response = appDelegate.services.registerUser(user: self.tempUser)
                        
                        DispatchQueue.main.async {
                            
                            self.redirectToVC(storyboardId: StoryboardIds.MainNavigationController, type: .present)
                            return
                            
                            if response?.status == ResponseStatus.SUCCESS.rawValue {
                                if let json = response?.json?.first {
                                    if let jsonUser = json["user"] as? NSDictionary {
                                        if let user = User.init(dictionary: jsonUser) {
                                            currentUser = user
                                            
                                            if let userId = currentUser.id {
                                                DispatchQueue.global(qos: .background).async {
                                                    appDelegate.services.updateAvatar(userId: userId, image: self.tempUser.image!, completion: { data in
                                                        
                                                        DispatchQueue.main.async {
                                                            if let json = data.json?.first {
                                                                if let status = json["status"] as? Int, status == ResponseStatus.SUCCESS.rawValue {
                                                                    self.saveUserInUserDefaults()
                                                                    
                                                                    self.redirectToVC(storyboardId: StoryboardIds.MainNavigationController, type: .push)
                                                                } else {
                                                                    self.showAlertView(message: ResponseMessage.SERVER_UNREACHABLE.rawValue)
                                                                }
                                                            }
                                                            
                                                            self.hideLoader()
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            } else if let message = response?.message {
                                self.showAlertView(message: message)
                            }
                            
                            self.hideLoader()
                        }
                    }
                } else {
                    self.showAlertView(message: "PICK YOUR PREFERRABLE PHOTO THAT WILL APPEAR IN THE LEADERBOARD")
                }
                break
            default:
                break
            }
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        buttonContinue.setTitle("CONTINUE", for: .normal)
        switch buttonContinue.tag {
        case 3:
            labelStep.text = "STEP 2"
            labelTitle.text = "TELL US MORE ABOUT YOU"
            buttonBackWidthContraint.constant = 100
            collectionViewTeam.alpha = 0
            viewTakePicture.alpha = 0
            scrollViewInfo.alpha = 1
            buttonContinue.tag = 2
            break
        case 2:
            labelStep.text = "STEP 1"
            labelTitle.text = "PICK YOUR FAVORITE TEAM"
            buttonBackWidthContraint.constant = 0
            collectionViewTeam.alpha = 1
            viewTakePicture.alpha = 0
            scrollViewInfo.alpha = 0
            buttonContinue.tag = 1
            break
        default:
            break
        }
    }
    
    @IBAction func buttonGenderTapped(_ sender: Any) {
        self.showGenderPicker()
    }
    
    @IBAction func buttonCountryTapped(_ sender: Any) {
        let viewController = CountryPickerViewController()
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func buttonTakePictureTapped(_ sender: Any) {
        self.handleCameraTap()
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

extension SignupViewController: CountryPickerViewControllerDelegate {
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController) {
        self.dismissVC()
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country) {
        self.labelDialingCode.text = country.callingCode
        self.buttonCountry.setTitle(country.name, for: .normal)
        
        self.dismissVC()
    }
}
