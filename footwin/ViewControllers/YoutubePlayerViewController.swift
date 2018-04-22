//
//  YoutubePlayerViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/22/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import CountdownLabel

class YoutubePlayerViewController: BaseViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var viewCountdown: UIView!
    @IBOutlet weak var labelCountdown: CountdownLabel!
    
    var videoId: String = "Z5AD2z5TH6s"//"ir0G79oHXMc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupYoutubePlayer()
        
        if isAppActive {
            buttonSkip.alpha = 1
            self.view.bringSubview(toFront: buttonSkip)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        youtubePlayer.stopVideo()        
    }
    
    func setupYoutubePlayer() {
        self.showLoader()
        
        self.youtubePlayer.delegate = self
        
        let playerVars = [
            "autoplay" : 0,
            "controls" : 0,
            "rel" : 0,
            "fs" : 0
        ]
        self.youtubePlayer.load(withVideoId: videoId, playerVars: playerVars)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.hideLoader()
        
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            break
        case .playing:
            break
        case .ended:
            UIView.animate(withDuration: 0.3, animations: {
                self.youtubePlayer.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewCountdown.alpha = 1
                })
            })
            
            var worldCupDateString = "2018-06-16"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: worldCupDateString) {
                dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
                worldCupDateString = dateFormatter.string(from: date)
                if let finalDate = dateFormatter.date(from: worldCupDateString) {
                    labelCountdown.setCountDownDate(targetDate: finalDate as NSDate)
                    labelCountdown.start()
                }
            }
        case .paused:
            break
        default:
            break
        }
    }
    
    @IBAction func buttonSkipTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.LoginNavigationController, type: .present)
    }
    
    @IBAction func buttonWatchFullTapped(_ sender: Any) {
        if let url = URL(string: "https://www.youtube.com/watch?v=ir0G79oHXMc") {
            self.openURL(url: url)
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
