//
//  ArticlesViewModel.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import Foundation

protocol ArticlesDelegate : AnyObject {
    func articlesSet()
    func noMorePages()
    func foundError(_ error: ApiError)
}

class ArticlesViewModel : NSObject {
    
    weak var delegate : ArticlesDelegate? = nil
    var articles : [Article] = []{
        didSet{
            delegate?.articlesSet()
        }
    }
    var response : ArticlesResponse? = nil
    var nextPage : String? = nil
    var repo : Repo
    var page = 1
    var sourceId = ""
    
    init(_ repo : Repo, _ sourceId : String){
        self.repo = repo
        self.sourceId = sourceId
    }
    
    func getArticles(){
        
        page = 1
        nextPage = nil
        
        let url = "https://newsapi.org/v2/everything?sources=\(sourceId)"
        
        repo.getData(url, { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            res in
            self?.response = res
            if(self?.response?.status == "ok"){
                self?.articles = self?.response?.articles ?? []
                if(self?.response?.articles?.count ?? 0 == 100){
                    self?.page = (self?.page ?? 0) + 1
                    self?.nextPage = "https://newsapi.org/v2/everything?sources=\(self?.sourceId ?? "")&page=\(self?.page ?? 1)"
                }
            }
        })
    }
    
    func getArticlesByFilter(_ query : String){
        
        page = 1
        nextPage = nil
        
        var url = "https://newsapi.org/v2/everything?sources=\(sourceId)"
        
        if(query.isEmpty == true){
            return
        } else {
            url.append("&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)")
        }
        
        repo.getData(url, { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            res in
            self?.response = res
            if(self?.response?.status == "ok"){
                self?.articles = self?.response?.articles ?? []
                if(self?.response?.articles?.count ?? 0 < 100){
                    self?.page = (self?.page ?? 0) + 1
                    self?.nextPage = "https://newsapi.org/v2/everything?sources=\(self?.sourceId ?? "")&page=\(self?.page ?? 1)"
                }
            }
        })
    }
    
    func loadMore(){
        
        guard let nextPage = self.nextPage else {
            self.delegate?.noMorePages()
            return
        }
        
        repo.getData(nextPage, { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            res in
            self?.response = res
            if(self?.response?.status == "ok"){
                self?.articles.append(contentsOf: self?.response?.articles ?? [])
                if(self?.response?.articles?.count ?? 0 < 100){
                    self?.page = (self?.page ?? 0) + 1
                    self?.nextPage = (self?.nextPage ?? "").replacingOccurrences(of: "page=\((self?.page ?? 1) - 1)", with: "page=\(self?.page ?? 1)")
                }
            }
        })
    }
    
    
    
    
}
