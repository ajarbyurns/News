//
//  ArticlesModel.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import Foundation

struct ArticlesResponse : Decodable {
    
    let status: String?
    let totalResults : Int?
    let articles : [Article]?
    
}

struct Item : Decodable {
    let id : String?
    let name : String?
}

struct Article : Decodable {
    
    let source : Item?
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    
}
