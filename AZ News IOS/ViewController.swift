//
//  ViewController.swift
//  AZ News IOS
//
//  Created by omar adel on 19/04/2022.
//

import UIKit
import SafariServices
// 1- TableView
// 2- Custom cell
// 3- API Caller
// 4- Open the news Story
// 5- Search for News Stories

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    private let tableView :UITableView = {
        let table = UITableView()
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.identifier
        )
        return table
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    
    override func viewDidLoad() {
        super.viewDidLoad()        
        title = "AZ New"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        getTopStories()
    }
    
    private func getTopStories(){
        ApiCaller.shared.getTopStories { [weak self] result in
            switch(result){
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({NewsTableViewCellViewModel(
                    title: $0.title ?? "No title",
                    subTitile: $0.description ?? "No description",
                    urlToImage: URL(string: $0.urlToImage ?? "")
                )})
                
                // Refresh tableView
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    // Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // Table func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /** Gives a cast error*/
        
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: NewsTableViewCell.identifier,
//            for:indexPath
//        ) as? NewsTableViewCell else {
//            fatalError()
//        }

        /** alt for now*/
        let cell = NewsTableViewCell()
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView , didSelectRowAt indexPath:IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

