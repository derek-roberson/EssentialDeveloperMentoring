//
//  TextMessageViewController.swift
//  EssentialDeveloperMentoring
//
//  Created by Derek Roberson on 11/17/21.
//

import UIKit

protocol MessageServiceProtocol {
    func getLeadMessages(limit: String, lastEventDt: String, completion: @escaping (Result<[Message], Error>) -> Void)
    func sendLeadText(_ message: APIMessageObject, completion: @escaping ((Result<NoReply, Error>) -> Void))
    func changeAIStatus(_ aiStatusAction: AIStatusAction, mdid: String, completion: @escaping ((Result<NoReply, Error>) -> Void))
}

class MessageService: MessageServiceProtocol {
    func getLeadMessages(limit: String, lastEventDt: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        Networking.shared.getLeadMessages(limit: limit, lastEventDt: lastEventDt) { (result: Result<[Message], Error>) in
            print(result)
        }
    }
    
    func sendLeadText(_ message: APIMessageObject, completion: @escaping ((Result<NoReply, Error>) -> Void)) {
        Networking.shared.sendLeadText(message, completion: completion)
    }
    
    func changeAIStatus(_ aiStatusAction: AIStatusAction, mdid: String, completion: @escaping ((Result<NoReply, Error>) -> Void)) {
        Networking.shared.changeAIStatus(aiStatusAction, mdid: mdid, completion: completion)
    }
}

class TextMessageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We access User account singleton in this file. What other approaches can we use?
    }
}
