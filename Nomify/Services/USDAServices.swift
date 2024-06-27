//
//  USDAServices.swift
//  Nomify
//
//  Created by Andy Vu on 6/25/24.
//

import Foundation

struct FoodResult: Decodable {
    var totalHits: Int
    var foods: [Food]
}

struct Food: Decodable {
    var dataType: String
    var description: String
    var brandName: String?
}



class USDAServices {
    
    public static func getFoodData(barcodeId: String) async throws -> Food? {
        var request = URLRequest(url: URL(string: "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(barcodeId)&pageSize=1&api_key=\(APIKey.usdaValue)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let response = try? JSONDecoder().decode(FoodResult.self, from: data) {
                if response.totalHits > 0 {
                    return response.foods[0]
                }
                else {
                    return nil
                }
            }
            else {
                print("error decoding food response")
                return nil
            }
        }
        catch {
            print("error making request to usda API: " + error.localizedDescription)
            throw error
        }
    }
}
