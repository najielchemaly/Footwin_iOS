//
//  CoinStashViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CircleProgressView
//import GoogleMobileAds
import InMobiSDK

class CoinStashViewController: BaseViewController, UIScrollViewDelegate, IMInterstitialDelegate {

    @IBOutlet weak var labelTotalCoins: UILabel!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelMinimumCoins: UILabel!
    @IBOutlet weak var buttonGetCoins: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWatchVideo: UIButton!
    @IBOutlet weak var buttonGetCoinsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelCollect: UILabel!
    @IBOutlet weak var imageIconSmall: UIImageView!
    
    var coinsProgressView: CircleProgressView!
    
    var interstitialMobiVideo: IMInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
//        self.setupAddMob()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func viewWillLayoutSubviews() {
        imageViewHeightConstraint.constant = scrollView.contentSize.height > self.view.frame.size.height ? scrollView.contentSize.height : self.view.frame.size.height
        
//        scrollView.backgroundColor = UIColor(patternImage:  #imageLiteral(resourceName: "coins_background"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize.height += 50
    }
    
    func interstitialDidFinishLoading(_ interstitial: IMInterstitial!) {
        print("interstitialDidFinishLoading")
        
        self.hideLoader()
        if interstitial.isReady() {
            interstitial.show(from: self, with: .coverVertical)
        }
    }
    
    func interstitial(_ interstitial: IMInterstitial!, didFailToLoadWithError error: IMRequestStatus!) {
        print("Interstitial failed to load ad")
        self.hideLoader()
        
        self.showAlertView(message: "No available video, try again later!")
    }
    
    func interstitial(_ interstitial: IMInterstitial!, didFailToPresentWithError error: IMRequestStatus!) {
        print("Interstitial didFailToPresentWithError")
        self.hideLoader()
        
        self.showAlertView(message: "No available video, try again later!")
    }
    
    func interstitialWillPresent(_ interstitial: IMInterstitial!) {
        print("interstitialWillPresent")
    }
    
    func interstitialDidPresent(_ interstitial: IMInterstitial!) {
        print("interstitialDidPresent")
    }
    
    func interstitialWillDismiss(_ interstitial: IMInterstitial!) {
        print("interstitialWillDismiss")
    }
    
    func interstitialDidDismiss(_ interstitial: IMInterstitial!) {
        print("interstitialDidDismiss")
    }
    
    func userWillLeaveApplication(from interstitial: IMInterstitial!) {
        print("userWillLeaveApplicationFromInterstitial")
    }
    
    func interstitial(_ interstitial: IMInterstitial!, rewardActionCompletedWithRewards rewards: [AnyHashable : Any]!) {
        print("rewardActionCompletedWithRewards")
        
        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getReward(id: Objects.activeReward.id!, amount: Objects.activeReward.amount!)
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = response?.message {
                        self.showAlertView(message: message)
                    }
                    
                    if let json = response?.json?.first {
                        if let coins = json["coins"] as? String {
                            currentUser.coins = coins
                            
                            self.labelTotalCoins.text = coins
                            
                            self.saveUserInUserDefaults()
                        }
                    }
                }
                
                self.hideLoader()
            }
        }
    }
    
    func interstitial(_ interstitial: IMInterstitial!, didInteractWithParams params: [AnyHashable : Any]!) {
        print("InterstitialDidInteractWithParams")
    }
    
    func interstitialDidReceiveAd(_ interstitial: IMInterstitial!) {
        print("interstitialDidReceiveAd")
    }
    
    func setupAddMob() {
//        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }
    
//    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
//                            didRewardUserWith reward: GADAdReward) {
//        self.showLoader()
//        DispatchQueue.global(qos: .background).async {
//            let response = appDelegate.services.getReward(id: Objects.activeReward.id!, amount: Objects.activeReward.amount!)
//
//            DispatchQueue.main.async {
//                if response?.status == ResponseStatus.SUCCESS.rawValue {
//                    if let message = response?.message {
//                        self.showAlertView(message: message)
//                    }
//
//                    if let json = response?.json?.first {
//                        if let coins = json["coins"] as? String {
//                            currentUser.coins = coins
//
//                            self.labelTotalCoins.text = coins
//
//                            self.saveUserInUserDefaults()
//                        }
//                    }
//                }
//
//                self.hideLoader()
//            }
//        }
//        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
//    }
//
//    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
//        print("Reward based video ad is received.")
//
//        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
//            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
//        }
//    }
//
//    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        self.hideLoader()
//        print("Opened reward based video ad.")
//    }
//
//    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad started playing.")
//    }
//
//    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad has completed.")
//    }
//
//    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad is closed.")
//    }
//
//    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad will leave application.")
//    }
//
//    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
//                            didFailToLoadWithError error: Error) {
//        self.hideLoader()
//        self.showAlertView(message: "No available video, try again later!")
//        print("Reward based video ad failed to load.")
//    }
    
    func initializeViews() {
        labelTotalCoins.text = currentUser.coins
        labelWinningCoins.text = currentUser.winning_coins
        labelMinimumCoins.text = Objects.winningUser.winning_coins//Objects.activeRound.minimum_amount
        
        if labelMinimumCoins.text == nil || (labelMinimumCoins.text?.isEmpty)! || labelMinimumCoins.text == "0" {
            labelCollect.text = "KEEP WINNING COINS"
            labelMinimumCoins.isHidden = true
            imageIconSmall.isHidden = true
        }
        
        coinsProgressView = CircleProgressView(frame: progressView.bounds)
        coinsProgressView.trackBackgroundColor = Colors.appBlue.withAlphaComponent(0.25)
        coinsProgressView.trackFillColor = Colors.appBlue
        coinsProgressView.backgroundColor = .clear
        coinsProgressView.refreshRate = 0.001
        coinsProgressView.progress = 0
        progressView.addSubview(coinsProgressView)
        progressView.sendSubview(toBack: coinsProgressView)
        scrollView.delegate = self
        
        if let strMinimumCoins = self.labelMinimumCoins.text, let strWinningCoins = self.labelWinningCoins.text {
            if let minimumCoins = Double(strMinimumCoins), let winningCoins = Int(strWinningCoins) {
                self.updateWinningCoins(progress: minimumCoins, winning: winningCoins)
            }
        }
        
        if !isIAPReady {
            buttonGetCoinsHeightConstraint.constant = 0
            buttonGetCoins.isHidden = true
        }
    }
    
    func updateWinningCoins(progress: Double, winning: Int) {
        let countingProcess = CountingProcess(minValue: 0, maxValue: winning)
        countingProcess.simulateLoading(toValue: winning, valueChanged: { currentValue in
            self.labelWinningCoins.text = "\(currentValue)"
            self.coinsProgressView.progress = Double(currentValue)/progress
        })
    }
    
    @IBAction func buttonGetCoinsTapped(_ sender: Any) {
        if let purchaseCoins = self.showView(name: Views.PurchaseCoins) as? PurchaseCoins {
            purchaseCoins.setupPagerView()
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonWatchVideoTapped(_ sender: Any) {
        self.showLoader()
        
        interstitialMobiVideo = IMInterstitial(placementId: INMOBI_INTERSTITIAL_PLACEMENT_VIDEO, delegate: self)
        if let interstitial = interstitialMobiVideo {
            interstitial.load()
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
