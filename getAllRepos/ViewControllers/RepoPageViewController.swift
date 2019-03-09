//
//  RepoPageViewController.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 06/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class RepoPageViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var numberOfForksLabel: UILabel!
    @IBOutlet weak var numberOfWatchersLabel: UILabel!
    @IBOutlet weak var urlButtonOutlet: UIButton!
    @IBOutlet weak var readmeButtonOutlet: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var readMeWebView: WKWebView!
    @IBOutlet weak var closeWebViewButton: UIButton!
    
    var repo: Repository?
    var owner: Owner?
    var readMeUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details Page"
        getReadMeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let repo = repo else {
            return
        }
        configureUI(repo)
    }
    
    func configureUI(_ repo: Repository) {
        numberOfStarsLabel.text = String(repo.stargazersCount)
        numberOfForksLabel.text = String(repo.forksCount)
        numberOfWatchersLabel.text = String(repo.watchersCount)
        nameLabel.text = repo.repoName
        languageLabel.text = repo.language
        descriptionLabel.text = repo.descriptionText
        if let url = URL(string: (owner?.avatarURL)!) {
            downloadImage(from: url)
        }
        urlButtonOutlet.layer.cornerRadius = 5
        readmeButtonOutlet.layer.cornerRadius = 5
    }
    
    func getReadMeData() {
        if let owner = owner?.login, let repo = repo?.repoName {
            let query = "\(owner)/\(repo)/readme"
            if query == "" { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            RequestData(query: query).requestReadMe { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .successForReadMe(let response):
                    self.readMeUrl.append(contentsOf: response.htmlUrl)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let okAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        self.showAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert, actions: [okAlertAction])
                    }
                case .success(_):
                    return
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.avatarImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func urlButtonTapped(_ sender: Any) {
        guard let urlStr = repo?.htmlUrl else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func closeWebViewButtonTapped(_ sender: Any) {
        self.readMeWebView.isHidden = true
        self.closeWebViewButton.isHidden = true
    }
    
    @IBAction func readMeButtonTapped(_ sender: Any) {
        
        if let url = URL(string: self.readMeUrl) {
            let requestObj = URLRequest(url: url as URL)
            self.readMeWebView.load(requestObj)
        }
        self.readMeWebView.isHidden = false
        self.closeWebViewButton.isHidden = false
    }
    
}


