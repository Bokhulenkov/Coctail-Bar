//
//  CoctailData.swift
//  Coctail Bar
//
//  Created by Alexander Bokhulenkov on 25.06.2024.
//

import Foundation

struct CoctailData: Codable {
    
    let ingredients: [String]
    let instructions: String
    let name: String
}

enum Constants {
    static let url = "https://api.api-ninjas.com/v1/cocktail?name="
    static let key = "TmPECHVV1YRDOUsjy2SRYw==pK001QOQwMlPKU1e"
    static let name = "mojito".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
}
