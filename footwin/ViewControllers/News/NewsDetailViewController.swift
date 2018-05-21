//
//  NewsDetailViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class NewsDetailViewController: BaseViewController {

    static var selectedArticle: Article = Article()
    var article: Article!
    
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
    }
    
    override func viewWillLayoutSubviews() {
        self.updateScrollViewContentSize()
    }
    
    func initializeViews() {
        article = NewsDetailViewController.selectedArticle
        if let imgUrl = article.url_to_image, !imgUrl.isEmpty {
            imageNews.kf.setImage(with: (URL(string: imgUrl)))
        }
        labelTitle.text = article.title
        textViewDescription.text = article.desc
        
        if let publishedAt = article.published_at {
            let dateArray = publishedAt.split(separator: "-")
            let timeArray = dateArray[2].split(separator: "T")
            let dateString = dateArray[0]+"-"+dateArray[1]+"-"+timeArray[0]
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "dd MMM yyyy"
                labelDate.text = dateFormatter.string(from: date)
            }
        }
    }
    
    let padding: CGFloat = 20
    func updateScrollViewContentSize() {
        if let descriptionHeight = NewsDetailViewController.selectedArticle.desc?.height(width: textViewDescription.frame.size.width, font: textViewDescription.font!) {
            let height = (descriptionHeight+padding)
            let diffHeight = height - textViewHeightConstraint.constant
            textViewHeightConstraint.constant = height > textViewHeightConstraint.constant ? height+(padding*2) : textViewHeightConstraint.constant
            let scrollViewHeight = diffHeight > 0 ? (scrollView.frame.size.height + diffHeight) : scrollView.frame.size.height
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
