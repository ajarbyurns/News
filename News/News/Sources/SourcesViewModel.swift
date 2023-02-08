//
//  SourcesViewModel.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import Foundation

protocol SourcesDelegate : AnyObject {
    func sourcesSet()
    func noMorePages()
    func foundError(_ error: ApiError)
}

class SourcesViewModel : NSObject {
    
    weak var delegate : SourcesDelegate? = nil
    var sources : [Source] = []{
        didSet{
            delegate?.sourcesSet()
        }
    }
    var response : SourcesResponse? = nil{
        didSet{
            if(response?.status == "ok"){
                self.sources = response?.sources ?? []
            }
        }
    }
    var repo : Repo
    var category : String
    
    init(_ repo : Repo, category : String){
        self.repo = repo
        self.category = category
    }
    
    func getSources(){
        
        let url = "https://newsapi.org/v2/top-headlines/sources?category=\(category)"
        
        repo.getData(url, { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            res in
            self?.response = res
        })
    }
    
    func getSourcesByFilter(_ lang : String? = nil, _ country : String? = nil){
        
        if(lang == nil && country == nil){
            return
        }
        
        var url = "https://newsapi.org/v2/top-headlines/sources?category=\(category)"
        
        if let lang = lang {
            url.append("language=\(lang)")
        }
        if let country = country {
            url.append("country=\(country)")
        }
        
        repo.getData(url, { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            res in
            self?.response = res
        })
    }
    
}
