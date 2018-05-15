//
//  CoinStashViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CircleProgressView

class CoinStashViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var labelTotalCoins: UILabel!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelMinimumCoins: UILabel!
    @IBOutlet weak var buttonGetCoins: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var coinsProgressView: CircleProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
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
    
//    override func viewWillLayoutSubviews() {
//        imageViewHeightConstraint.constant = scrollView.contentSize.height
//    }
    
    func initializeViews() {
        labelTotalCoins.text = currentUser.coins
        labelWinningCoins.text = currentUser.winning_coins
        labelMinimumCoins.text = Objects.activeRound.minimum_amount
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
