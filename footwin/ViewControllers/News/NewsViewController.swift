//
//  NewsViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getNews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNews() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getNews()
            
            DispatchQueue.main.async {
                if let json = response?.json?.first {
                    if let status = json["status"] as? String, status == "ok" {
                        if let jsonArray = json["articles"] as? [NSDictionary] {
                            Objects.articles = [Article]()
                            for json in jsonArray {
                                let article = Article.init(dictionary: json)
                                Objects.articles.append(article!)
                                
                                if Objects.articles.count == 20 {
                                    break
                                }
                            }
                        }
                    } else {
                        if let message = response?.message {
                            self.showAlertView(message: message)
                        }
                    }
                }
                
                self.hideLoader()
                self.refreshControl.endRefreshing()
                
                if Objects.articles.count == 0 {
                    self.addEmptyView(message: "IT SEEMS THERE ARE NO NEWS YET!!", frame: self.tableView.frame)
                } else {
                    Objects.articles = Objects.articles.filter{ $0.date != nil }.sorted(by: { $0.date?.compare($1.date!) == .orderedDescending })
                    
                    self.tableView.reloadData()
                    self.removeEmptyView()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.NewsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.NewsTableViewCell)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleRefresh(fromNotification: Bool = false) {
        if Objects.articles.count == 0 {
            self.showLoader()
        }
        
        self.getNews()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Objects.articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.NewsTableViewCell) as? NewsTableViewCell {
            cell.selectionStyle = .none
            
            let article = Objects.articles[indexPath.row]
            if let imgUrl = article.url_to_image, !imgUrl.isEmpty {
                cell.imageNews.kf.setImage(with: URL(string: imgUrl))
            }
            cell.labelTitle.text = article.title
            
            if let date = article.date {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .current
                dateFormatter.dateFormat = "dd MMM yyyy"
                cell.labelDate.text = dateFormatter.string(from: date)
            }
            
            cell.viewDate.clipsToBounds = true
            cell.viewDate.layer.cornerRadius = 15
            if #available(iOS 11.0, *) {
                cell.viewDate.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.viewDate.roundCorners([.topRight, .bottomRight], radius: 15)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NewsDetailViewController.selectedArticle = Objects.articles[indexPath.row]
        self.redirectToVC(storyboardId: StoryboardIds.NewsDetailViewController, type: .present)
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
