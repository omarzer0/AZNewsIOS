//
//  NewsTableViewCell.swift
//  AZ News IOS
//
//  Created by omar adel on 19/04/2022.
//

import UIKit

class NewsTableViewCellViewModel {
    let title : String?
    let subTitile : String?
    let urlToImage: URL?
    var imageData:Data? = nil
    
    init(
         title : String?,
         subTitile : String?,
         urlToImage: URL?
    ){
        self.title = title
        self.subTitile = subTitile
        self.urlToImage = urlToImage
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel:UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 22, weight:.semibold)
        return lable
    }()
    
    private let newsSubTitleLabel:UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 18, weight:.light)
        return lable
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.backgroundColor = .secondarySystemBackground
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubTitleLabel)
        contentView.addSubview(newsImageView)
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170 ,
            height: 70
        )
        
        
        newsSubTitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height-10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsSubTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel:NewsTableViewCellViewModel){
        newsTitleLabel.text = viewModel.title
        newsSubTitleLabel.text = viewModel.subTitile
        // We have a cashed image
        if let data = viewModel.imageData{
            print("image exsits success")
            newsImageView.image = UIImage(data: data)
        }
        
        // Fetch image from network
        
        else if let url = viewModel.urlToImage {
            URLSession.shared.dataTask(with: url){[weak self] data, _, error in
                guard let data = data , error == nil else {
                    // not success
                    print("image downlaod error \(String(describing: error))")
                    return
                }
                viewModel.imageData = data
            
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
        
    }
    
}
