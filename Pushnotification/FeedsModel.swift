//
//  FeedsModel.swift
//  Pushnotification
//
//  Created by ios on 06/03/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit


class Paginator : Codable   {
    var totalCount : Int?
    var currentPage : Int?
    var lastPage : Int?
    var aryCovers :  [FeedsModel] = []
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case aryCovers = "data"
    }
}

class FeedsModel: Codable    {
    var id : Int?
    var title : String?
    var desc : String?
    var user : User?
    var thumbFilePath : String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case desc = "description"
        case user = "user"
        case thumbFilePath = "thumb_file_path"
    }
}

class User : Codable {
    var id : Int?
    var name : String?
}
