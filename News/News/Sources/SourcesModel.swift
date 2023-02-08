//
//  SourcesModel.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import Foundation

struct SourcesResponse : Decodable {
    
    let status: String?
    let sources : [Source]?
    
}

struct Source : Decodable {
    
    let id : String?
    let name : String?
    let description : String?
    let url : String?
    let category : String?
    let language : String?
    let country : String?
    
}
