//
//  EditProfileViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, ImagePickerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewFullname: UIView!
    @IBOutlet weak var textFieldFullname: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var buttonCountry: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var labelDialingCode: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var buttonGender: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewOverlay: UIView!
    
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
        self.setupDelegates()
        self.fillUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillUserInfo() {
        textFieldFullname.text = currentUser.fullname
        textFieldEmail.text = currentUser.email
        buttonCountry.setTitle(currentUser.country, for: .normal)
        labelDialingCode.text = currentUser.phone_code
        textFieldPhone.text = currentUser.phone
        buttonGender.setTitle(currentUser.gender, for: .normal)
    }
    
    func initializeViews() {
        self.viewFullname.customizeBorder(color: Colors.white)
        self.viewEmail.customizeBorder(color: Colors.white)
        self.viewPhone.customizeBorder(color: Colors.white)
        self.viewGender.customizeBorder(color: Colors.white)
        self.viewCountry.customizeBorder(color: Colors.white)
        
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.size.width/2
        self.viewOverlay.layer.cornerRadius = self.viewOverlay.frame.size.width/2
        if let avatar = currentUser.avatar, !avatar.isEmpty {
            self.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl() + avatar))
        } else {
            if let gender = currentUser.gender, gender.lowercased() == "male" {
                self.imageViewProfile.image = #imageLiteral(resourceName: "avatar_male")
            } else if let gender = currentUser.gender, gender.lowercased() == "female" {
                self.imageViewProfile.image = #imageLiteral(resourceName: "avatar_female")
            }
        }
        
        labelName.text = currentUser.fullname?.uppercased()
        
        if isReview {
            self.textFieldPhone.placeholder = "(Optional)"
            self.buttonGender.setTitle("(Optional)", for: .normal)
        }
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
    
    func setupDelegates() {
        textFieldFullname.delegate = self
        textFieldEmail.delegate = self
        
        self.imagePickerDelegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        errorMessage = textFieldFullname.validate(validationType: .MaxLength, fieldType: .Fullname)
        if !errorMessage.isEmpty {
            return false
        }
        errorMessage = textFieldEmail.validate(validationType: .Regex, fieldType: .Email)
        if !errorMessage.isEmpty {
            return false
        }
        errorMessage = buttonCountry.validate(fieldType: .Phone)
        if !errorMessage.isEmpty {
            return false
        }
        if !isReview {
            errorMessage = textFieldPhone.validate(validationType: .MinLength, fieldType: .Phone)
            if !errorMessage.isEmpty {
                return false
            }
            errorMessage = textFieldPhone.validate(validationType: .MaxLength, fieldType: .Phone)
            if !isReview && !errorMessage.isEmpty {
                return false
            }
            errorMessage = buttonGender.validate(fieldType: .Phone)
            if !isReview && !errorMessage.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            self.imageViewProfile.image = image
        }
    }
    
    func didCancelPickingMedia() {
        
    }
    
    @IBAction func buttonCountryTapped(_ sender: Any) {
        if let countryViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.CountryViewController) as? CountryViewController {
            countryViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: countryViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonGenderTapped(_ sender: Any) {
        self.showGenderPicker()
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let userId = currentUser.id
            let fullname = textFieldFullname.text
            let country = buttonCountry.titleLabel?.text
            let phone_code = labelDialingCode.text
            let phone = textFieldPhone.text
            let email = textFieldEmail.text
            let gender = buttonGender.titleLabel?.text
            
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.editUser(id: userId!, fullname: fullname!, email: email!, country: country!, phone_code: phone_code!, phone: phone!, gender: gender!)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let json = response?.json?.first {
                            if let jsonUser = json["user"] as? NSDictionary {
                                if let user = User.init(dictionary: jsonUser) {
                                    currentUser = user
                                    
                                    self.saveUserInUserDefaults()
                                    self.updateImageProfile()
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
            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonCameraTapped(_ sender: Any) {
        self.handleCameraTap()
    }
    
    func updateImageProfile() {
        if let userId = currentUser.id, let image = imageViewProfile.image {
            DispatchQueue.global(qos: .background).async {
                appDelegate.services.updateAvatar(userId: userId, image: image, completion: { data in
                    
                    DispatchQueue.main.async {
                        if let json = data.json?.first {
                            if let status = json["status"] as? Int, status == ResponseStatus.SUCCESS.rawValue {
                                self.saveUserInUserDefaults()
                                
                                self.showAlertView(message: "YOUR PROFILE HAS BEEN UPDATED SUCCESSFULLY")
                                self.alertView.buttonDone.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
//                                self.showAlertView(message: "YOUR PROFILE PICTURE HAS BEEN UPDATED SUCCESSFULLY")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController: CountryPickerDelegate {
    func didSelecteCountry(country: Country) {
        self.labelDialingCode.text = country.dialing_code
        self.buttonCountry.setTitle(country.name, for: .normal)
        
        self.dismissVC()
    }
}
