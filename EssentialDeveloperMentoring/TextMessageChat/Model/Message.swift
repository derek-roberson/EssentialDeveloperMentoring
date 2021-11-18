//
//  Message.swift
//  
//
//  Created by _ on 7/6/21.
//

import Foundation

public enum MessageType: String {
    case aiAutotrackMessage = "AIAutotrackMessage"
    case aiConversationMute = "AIConversationMute"
    case aiConversationUnmute = "AIConversationUnmute"
    case aiMessage = "AIMessage"
    case autoTrackText = "AutoTrackText"
    case behavioralEmail = "BehavioralEmail"
    case behavioralText = "BehavioralText"
    case dripMessage = "DripMessage"
    case dripSMS = "DripSMS"
    case message = "Message"
    case planEmail = "PlanEmail"
    case planSMS = "PlanSMS"
    case sms = "SMS"
}

struct Message: Decodable {
    let messageId: String
    var date: String
    let serverDate: String
    let description: String
    let type: MessageType
    let details: [MessageDetail]?
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()

    enum CodingKeys: String, CodingKey {
        case date
        case description
        case details
        case id
        case related
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try container.decode(String.self, forKey: .id)
        serverDate = try container.decode(String.self, forKey: .date)
//        date = serverDate.formatDateFromString(with: "MMM d 'at' h:mm a")
        date = ""
        if let formattedDate = Date.dateWithFormat(serverDate, convertServerTimeZone: true)?.string(with: "MMM d 'at' h:mm a") {
            date = formattedDate
        }
        description = try container.decode(String.self, forKey: .description)
        let messageType = try container.decode(String.self, forKey: .type)
        type = MessageType(rawValue: messageType)!
        // Check the conditions to see when details vs related is nil in API response
        if let messageDetails = try container.decodeIfPresent([MessageDetail].self, forKey: .details) {
            details = messageDetails
            
        } else if let messageRelated = try container.decodeIfPresent(MessageDetail.self, forKey: .related) {
            details = [messageRelated]
        } else {
            details = nil
        }
    }
}

struct MessageDetail: Decodable {
    let toMember: Member?
    let fromMember: Member?
    let sentTime: String?
    let isDrip: Bool?
    let isPlip: Bool?
    let attachments: [String]?
    
    enum CodingKeys: String, CodingKey {
        case toMember
        case fromMember
        case sentTime
        case isDrip
        case isPlip
        case attachments
        
    }
    
    init(member: Member) {
        self.toMember = nil
        self.fromMember = member
        self.sentTime = nil
        self.isDrip = nil
        self.isPlip = nil
        self.attachments = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        toMember = try container.decodeIfPresent(Member.self, forKey: .toMember)
        fromMember = try container.decodeIfPresent(Member.self, forKey: .fromMember)
        sentTime = try container.decodeIfPresent(String.self, forKey: .sentTime)
        isDrip = try container.decodeIfPresent(Bool.self, forKey: .isDrip)
        isPlip = try container.decodeIfPresent(Bool.self, forKey: .isPlip)
        attachments = try container.decodeIfPresent([String].self, forKey: .attachments)
    }
}

struct Member: Decodable {
    let mdid: String
    let firstName: String
    let lastName: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case mdid
        case firstName
        case lastName
    }
    
    init(firstName: String, lastName: String, mdid: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = firstName + " " + lastName
        self.mdid = mdid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mdid = try container.decode(String.self, forKey: .mdid)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        displayName = firstName + lastName
    }
}

struct NoReply: Decodable {
    let reply: String
    
    enum CodingKeys: String, CodingKey {
        case reply
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reply = try container.decodeIfPresent(String.self, forKey: .reply) ?? ""
    }
    
    init() {
        self.reply = ""
    }
}

enum AIStatus: String {
    case active = "Active"
    case muted = "Muted"
}

enum AIStatusAction: String {
    case mute = "muteai"
    case unmute = "unmuteai"
}

struct LeadAIStatus: Decodable {
    var status: AIStatus? = nil
    
    enum CodingKeys: String, CodingKey {
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let aiStatus = try container.decodeIfPresent(String.self, forKey: .status) {
            status = AIStatus(rawValue: aiStatus)
        } else {
            status = nil
        }
    }
}

struct APIMessageObject {
    let recipients: String
    let ccAddress = ""
    let bccAddress = ""
    let templateID: String
    let subject: String
    var messageType = "text"
    let body: String
    let unbranded: Bool
    let attachedProps: String
    let attachedFiles: String
    let attachedVideo: JSONDictionary
}
