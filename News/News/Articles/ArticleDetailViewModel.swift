//
//  ArticleDetailViewModel.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import Foundation

protocol ArticleDetailDelegate : AnyObject {
    func imageLoaded(_ imageData : Data)
    func foundError(_ error : ApiError)
}

var imageDataCache = NSCache<AnyObject, AnyObject>()

class ArticleDetailViewModel : NSObject {
    
    weak var delegate : ArticleDetailDelegate?
    
    var article: Article
    var imgData : Data?{
        didSet{
            if let data = imgData {
                delegate?.imageLoaded(data)
            }
        }
    }
    var repo : Repo
    
    init(_ input : Article, _ repo : Repo){
        self.article = input
        self.imgData = imageDataCache.object(forKey: input.urlToImage as AnyObject) as? Data
        self.repo = repo
    }
    
    func loadImage(){
        
        if let imgData = imgData {
            delegate?.imageLoaded(imgData)
            return
        }
        
        repo.getImageData(article.urlToImage ?? "", { [weak self]
            error in
            self?.delegate?.foundError(error)
        }, { [weak self]
            data in
            imageDataCache.setObject(data as AnyObject, forKey: self?.article.urlToImage as AnyObject)
            self?.imgData = data
        })
    }
    
    private func UTCToLocal() -> String {
        
        guard let date = article.publishedAt else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let dt = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "HH:mm, MMMM yyyy"

            return dateFormatter.string(from: dt)
        } else {
            return date
        }
    }
}
