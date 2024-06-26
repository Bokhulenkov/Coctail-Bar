//
//  CoctailManager.swift
//  Coctail Bar
//
//  Created by Alexander Bokhulenkov on 25.06.2024.
//

import Foundation
import UIKit

protocol CoctailManagerDelegate {
    func didReceivCoctail(_ coctailManager: CoctailManager, coctailData: CoctailData)
    func didFailWithError(error: Error)
}

struct CoctailManager {
    
    let apiURL = Constants.url
    let apiKey = Constants.key
    
    
    var delegate: CoctailManagerDelegate?
    
    func performRequest(_ coctailName: String) {
        //        создаем string название коктеля из полученныйх данных
        guard let stringName = coctailName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: "\(apiURL)\(stringName)") else { return }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let safeData = data else { return }
            guard let coctailData = parseJSON(safeData) else { return }
            delegate?.didReceivCoctail(self, coctailData: coctailData)
        }
        task.resume()
    }
    
    func parseJSON(_ coctailData: Data) -> CoctailData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CoctailData].self, from: coctailData)
            
            let ingredients = decodedData[0].ingredients
            let instructions = decodedData[0].instructions
            let name = decodedData[0].name
            
            let coctailData = CoctailData(ingredients: ingredients, instructions: instructions, name: name)
            
            return coctailData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
