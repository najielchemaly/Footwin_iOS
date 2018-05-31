//
//  WebViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    static var comingFrom = WebViewComingFrom.None
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupWebview()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let helperView = appDelegate.window?.subviews.last as? HelperView {
            helperView.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func initializeViews() {
        if WebViewController.comingFrom.hashValue == WebViewComingFrom.Terms.hashValue {
            self.labelTitle.text = "TERMS & CONDITIONS"
        } else if WebViewController.comingFrom.hashValue == WebViewComingFrom.Privacy.hashValue {
            self.labelTitle.text = "PRIVACY POLICY"
        }
    }
    
    func setupWebview() {
        self.webView.delegate = self
        
        if WebViewController.comingFrom.hashValue == WebViewComingFrom.Terms.hashValue {
            if let termsUrl = URL.init(string: termsUrlString) {
                let request = URLRequest.init(url: termsUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                self.webView.loadRequest(request)
            }
        } else if WebViewController.comingFrom.hashValue == WebViewComingFrom.Privacy.hashValue {
            if let privacyUrl = URL.init(string: privacyUrlString) {
                let request = URLRequest.init(url: privacyUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                self.webView.loadRequest(request)
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showLoader()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideLoader()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hideLoader()
        
        self.showAlertView(message: "An error has occured, please try again later!")
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
