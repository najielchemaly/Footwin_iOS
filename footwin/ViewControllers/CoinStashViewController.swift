//
//  CoinStashViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CircleProgressView

class CoinStashViewController: BaseViewController {

    @IBOutlet weak var labelTotalCoins: UILabel!
    @IBOutlet weak var coinsProgressView: CircleProgressView!
    @IBOutlet weak var labelWinningCoins: UILabel!
    @IBOutlet weak var labelMinimumCoins: UILabel!
    @IBOutlet weak var buttonGetCoins: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.getPackages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        // TODO
        labelTotalCoins.text = currentUser.coins ?? "1200"
        labelWinningCoins.text = currentUser.winning_coins ?? ""
        labelMinimumCoins.text = Objects.activeRound.minimum_amount ?? labelMinimumCoins.text
        
        coinsProgressView.backgroundColor = UIColor.clear
        coinsProgressView.progress = 0
        coinsProgressView.refreshRate = 0.005
    }
    
    func getPackages() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getPackages()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["packages"] as? [NSDictionary] {
                            Objects.packages = [Package]()
                            for json in jsonArray {
                                let package = Package.init(dictionary: json)
                                Objects.packages.append(package!)
                            }
                        }
                    }
                }
                
                self.hideLoader()
                
                if let strMinimumCoins = self.labelMinimumCoins.text {
                    if let minimumCoins = Double(strMinimumCoins) {
                        self.updateWinningCoins(progress: minimumCoins)
                    }
                }
            }
        }
    }
    
    func updateWinningCoins(progress: Double) {
        let countingProcess = CountingProcess(minValue: 0, maxValue: 300)
        countingProcess.simulateLoading(toValue: 300, valueChanged: { currentValue in
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
