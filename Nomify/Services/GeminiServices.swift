//
//  GeminiServices.swift
//  Nomify
//
//  Created by Andy Vu on 6/16/24.
//

import Foundation

struct GenerateContentRequest: Encodable {
    var contents: [GeminiContent]
    var systemInstruction: GeminiContent
    var safetySettings: [SafetySetting]
}

struct SafetySetting: Codable {
    var category: String
    var threshold: String
}

struct GeminiContent: Codable {
    var parts: [Part]
}

struct Part: Codable {
    var text: String
}

struct GenerateContentResponse: Decodable {
    var candidates: [Candidate]
}

struct Candidate: Codable {
    var content: GeminiContent
}

struct FoodAnalysis: Codable {
    var recommendation: String
    var riskRating: [String: Int]
    var overallRiskRating: Int
    var alternatives: [Alternative]
}

struct Alternative: Codable {
    var name: String
    var url: String
}

class GeminiServices {
    
    public static func getAnalysis(foodItem: String, allergenProfile: [String:String]) async throws -> FoodAnalysis? {
        var request = URLRequest(url: URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=\(APIKey.geminiValue)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var prompt = "I'm "
        
        for (allergen, sev) in allergenProfile {
            if sev != "Not Allergic" {
                if prompt != "I'm " {
                    prompt.append(" and " + sev + " to " + allergen)
                }
                else {
                    prompt.append(sev + " to " + allergen)
                }
            }
        }
        
        if prompt == "I'm " {
            prompt = "I'm not allergic to anything"
        }
        
        prompt.append(". Can I consume \(foodItem)?")
        
        print(prompt)
        
        let postBody = GenerateContentRequest(contents: [GeminiContent(parts: [Part(text: prompt)])], systemInstruction: GeminiContent(parts: [Part(text: "I will give you a list of my food allergies. Your job is to give me a recommendation as to whether I should consume a given food. Base your recommendation primarily on the ingredients of the food item. For instance, if I enter \"Kit Kat\", make your recommendation based on the ingredients of a Kit Kat. Make sure to also account for the chance of cross contamination. Chance of cross contamination can only account for a maximum of 40% of the risk factors. Also, if you are unsure of whether or not I can consume an item, always err on the side of caution. If I can't consume it, give me a list of alternative brands or recipes I can consume instead with a url to that brand or recipe. Do not include alternatives that contain ingredients that are unsafe for any of my allergies. For example, if I'm allergic to eggs and dairy, give me alternatives that are both egg-free and dairy-free. Each url to a brand you give me should be in the format of \"https://www.google.com/search?q={name_of_brand_goes_here}\", and each url to a recipe should be in the format of \"https://www.google.com/search?q={name_of_recipe_goes_here}\". If you can't find alternatives within 5 seconds, leave the alternatives field as an empty array. Additionally, for each food item give me a risk rating from 0% to 100%. You must respond in JSON format with the following schema: \n recommendation: a short recommendation on whether I should consume the food item that addresses each one of my allergens. \n riskRating: Dictionary mapping of key-value pairs where the key represents the allergen (string) and the value is the risk rating of that allergen in the given food item as an integer data type. \n overallRiskRating: an overall risk rating of the food item as an integer data type. It should be the maximum value out of the riskRating values. \n alternatives: List of alternative recipes and brands with their urls if available in the format of: \n name: name of brand or recipe, \n url: url of brand or recipe. \n  \n If you cannot identify the food item I've given or if the item I've given you is not a food, you must respond in JSON with: \n error: Couldn't identify food item. \n In the JSON response, do not include the ```json in the beginning and the ``` at the end. If I'm not allergic to anything, set the riskRating field in your response to an empty dictionary.")]), safetySettings: [SafetySetting(category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "BLOCK_ONLY_HIGH")])
        
        do {
            let postBodyData = try JSONEncoder().encode(postBody)
            request.httpBody = postBodyData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let response = try? JSONDecoder().decode(GenerateContentResponse.self, from: data) {
                let foodAnalysis = createFoodAnalysis(stringJSON: response.candidates[0].content.parts[0].text)
                print(foodAnalysis)
                return foodAnalysis
            }
            else {
                print("error with response")
                return nil
            }
        }
        catch {
            throw error
        }
    }
    
    public static func createFoodAnalysis(stringJSON: String) -> FoodAnalysis? {
        guard let jsonData = stringJSON.data(using: .utf8) else {
            print("error with jsonData")
            return nil
        }
        
        if let foodAnalysis = try? JSONDecoder().decode(FoodAnalysis.self, from: jsonData) {
            return foodAnalysis
        }
        else {
            print("error with foodAnalysis")
            return nil
        }
    }
}
