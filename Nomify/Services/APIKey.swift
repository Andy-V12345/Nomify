//
//  APIKey.swift
//  Nomify
//
//  Created by Andy Vu on 6/25/24.
//

import Foundation

enum APIKey {
    static var geminiValue: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Api_key") as? String else {
            fatalError("Couldn't find key 'Api_key' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
    
    static var usdaValue: String {
        guard let filePath = Bundle.main.path(forResource: "USDAService-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'USDAService-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Api_key") as? String else {
            fatalError("Couldn't find key 'Api_key' in 'USDAService-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError(
                "No API key found!"
            )
        }
        return value
    }
}
