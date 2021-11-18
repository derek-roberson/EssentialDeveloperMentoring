//
//  JsonLoader.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import Foundation

struct JSONLoader {
    static func loadJson(file name: String) -> JSONDictionary? {
        guard
            let path = Bundle.main.path(forResource: name, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSONDictionary
                else { return nil }
        return json
    }
    
    static func loadJsonData(file name: String) -> Data? {
        guard
            let path = Bundle.main.path(forResource: name, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                else { return nil }
        return data
    }
}
