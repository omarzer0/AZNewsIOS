//
//  ApiCalle.swift
//  AZ News IOS
//
//  Created by omar adel on 19/04/2022.
//

import Foundation

final class ApiCaller{
    static let shared = ApiCaller()
    
    struct Constants {
        
        static let topHeadLinesUrl = URL(string:"https://newsapi.org/v2/top-headlines?country=US&apiKey=1078058ec4144ea9b30741c553fd4128")
        
    }
    
    private init(){}
    
    
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        
        guard let url = Constants.topHeadLinesUrl else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){data,_,error in
            if let error = error{completion(.failure(error))}
            
            else if let data = data{
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self,from:data)
                    completion(.success(result.articles))
                    print("Articles \(result.articles.count)")
                }catch{
                    completion(.failure(error))
                    print("error \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
    }
}


// Models

struct ApiResponse :Codable {
    let articles: [Article]
}

struct Article:Codable{
    let source: Source?
    let title:String?
    let description:String?
    let url:String?
    let urlToImage:String?
    let publishedAt: String?
}

struct Source:Codable{
    let name:String?
}

