//
//  ViewController.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 06/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import UIKit

class RepoSearch: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repoTableView: UITableView!
    
    fileprivate var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.repoTableView.reloadData()
            }
        }
    }
    
    var owner: [Owner] = []
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RepoSearch: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repositories.count == 0 {
            tableView.setEmptyMessage("Search something")
        } else {
            tableView.restore()
        }
        
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = repositories[indexPath.row].fullName
        cell.textLabel?.textColor = UIColor.lightGray
        let starLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        starLabel.text = "★ \(self.repositories[indexPath.row].stargazersCount)"
        starLabel.textColor = UIColor.lightGray
        starLabel.textAlignment = .left
        starLabel.sizeToFit()
        cell.accessoryView = starLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepoPageViewController") as? RepoPageViewController {
            vc.repo = repositories[indexPath.row]
            vc.owner = repositories[indexPath.row].owner
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RepoSearch: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(search), userInfo: nil, repeats: false)
    }
    
    @objc func search() {
        repositories.removeAll()
        guard let query = searchBar.text else { return }
        if query == "" { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RequestData(query: query).request { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.repositories.append(contentsOf: response.items)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let okAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    self.showAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert, actions: [okAlertAction])
                }
            case .successForReadMe(_):
                return
            }
        }
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


