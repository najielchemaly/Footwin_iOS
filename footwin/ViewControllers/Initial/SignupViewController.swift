//
//  SignupStep1ViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupCollectionView()
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
    }
    
    func setupCollectionView() {
        self.collectionViewTeam.register(UINib.init(nibName: CellIdentifiers.TeamCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: "TeamCollectionViewCell")
        
        self.collectionViewTeam.delegate = self
        self.collectionViewTeam.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell {
            if cell.selectedTeamOverlay.alpha == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.selectedTeamOverlay.alpha = 1
                    cell.selectedCheckmark.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.selectedTeamOverlay.alpha = 0
                    cell.selectedCheckmark.alpha = 0
                })
            }
        }
    }
    
    let itemSpacing: CGFloat = 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width/2)-itemSpacing
        let itemHeight = (collectionView.bounds.width/2)//+itemSpacing
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.TeamCollectionViewCell, for: indexPath) as? TeamCollectionViewCell {
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonContinueTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case 1:
                
                labelStep.text = "STEP 2"
                labelTitle.text = "TELL US MORE ABOUT YOU"
                buttonBackWidthContraint.constant = 100
                collectionViewTeam.alpha = 0
                viewTakePicture.alpha = 0
                scrollViewInfo.alpha = 1
                button.tag = 2
                break
            case 2:
                labelStep.text = "STEP 3"
                labelTitle.text = "SET YOUR PROFILE PICTURE"
                buttonContinue.setTitle("LET'S START", for: .normal)
                collectionViewTeam.alpha = 0
                viewTakePicture.alpha = 1
                scrollViewInfo.alpha = 0
                button.tag = 3
                break
            case 3:
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
        
    }
    
    @IBAction func buttonCountryTapped(_ sender: Any) {
        
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
