//
//  StorageServices.swift
//  Nomify
//
//  Created by Andy Vu on 6/26/24.
//

import Foundation

struct ProcessedFood: Codable {
    var foodItem: String
}

struct ImageRequest: Codable {
    var encodedImage: String
}

struct ImageResponse: Codable {
    var msg: String
}


class APIServices {
    public static func analyzeFoodImage(encodedImage: String) async -> ProcessedFood? {
        do {
            var request = URLRequest(url: URL(string: "https://us-central1-nomify-79449.cloudfunctions.net/analyzeFoodImage")!)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let postBody = ImageRequest(encodedImage: encodedImage)
            let postBodyData = try JSONEncoder().encode(postBody)
            
            request.httpBody = postBodyData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let response = try JSONDecoder().decode(ImageResponse.self, from: data)
            
            let processedFood = stringToJson(jsonString: response.msg)
            return processedFood
        }
        catch {
            print(error)
            return nil
        }
    }
    
    static func stringToJson(jsonString: String) -> ProcessedFood? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("error with jsonData")
            return nil
        }
        
        if let processedFood = try? JSONDecoder().decode(ProcessedFood.self, from: jsonData) {
            return processedFood
        }
        else {
            print("error with processedFood")
            return nil
        }
    }
}

