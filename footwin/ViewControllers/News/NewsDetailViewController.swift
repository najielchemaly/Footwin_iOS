//
//  NewsDetailViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class NewsDetailViewController: BaseViewController {

    static var selectedNews: News = News()
    var news: News!
    
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateScrollViewContentSize()
    }
    
    func initializeViews() {
        news = NewsDetailViewController.selectedNews
        if let imgUrl = news.img_url {
            imageNews.kf.setImage(with: (URL(string: imgUrl)))
        }
        labelDate.text = news.date
        labelTitle.text = news.title
        textViewDescription.text = news.desc
    }
    
    func updateScrollViewContentSize() {
        if let descriptionHeight = NewsDetailViewController.selectedNews.desc?.height(width: textViewDescription.frame.size.width, font: textViewDescription.font!) {
            textViewHeightConstraint.constant = descriptionHeight
            let scrollViewHeight = (scrollView.frame.size.height-textViewDescription.frame.size.height) + descriptionHeight
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollViewHeight)
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
