//
//  Networking.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import Foundation

public typealias SuccessBlock = () -> Void
public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [JSONDictionary]

class Networking {
    static let shared = Networking()
    
    private init() { }
    
    func login(success : @escaping SuccessBlock) {
        guard let json = JSONLoader.loadJson(file: "loginResponse") else { return }
        MyAccount.sharedInstance.updateWithDictionary(json as NSDictionary, success: success)
    }
    
    func getLeadMessages(limit: String, lastEventDt: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard
            let data = JSONLoader.loadJsonData(file: "messageResponse"),
            let messages = try? JSONDecoder().decode([Message].self, from: data)
        else {
            completion(.failure(anyError()))
            return
        }
        
        completion(.success(messages))
    }
    
    func sendLeadText(_ message: APIMessageObject, completion: @escaping ((Result<NoReply, Error>) -> Void)) {
        guard
            let data = JSONLoader.loadJsonData(file: "noReply"),
            let noReply = try? JSONDecoder().decode(NoReply.self, from: data)
        else {
            completion(.failure(anyError()))
            return
        }
        
        completion(.success(noReply))
    }
    
    func changeAIStatus(_ aiStatusAction: AIStatusAction, mdid: String, completion: @escaping ((Result<NoReply, Error>) -> Void)) {
        guard
            let data = JSONLoader.loadJsonData(file: "noReply"),
            let noReply = try? JSONDecoder().decode(NoReply.self, from: data)
        else {
            completion(.failure(anyError()))
            return
        }
        
        completion(.success(noReply))
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: [:])
    }
}


