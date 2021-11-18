//
//  HelperClasses.swift
//
//
//  Created by _ on 4/6/16.
//

import UIKit

class CalendarAccount: NSObject {
    
    var accessRole = ""
    var id = ""
    var primary = false
    var summary = ""
    
    init(withJson dict: JSONDictionary) {
        super.init()
        
        if let val = dict["accessRole"] as? String{
            accessRole = val
        }
        
        if let val = dict["id"] as? String{
            id = val
        }

        if let val = dict["primary"] as? Bool{
            primary = val
        }
        
        if let val = dict["summary"] as? String{
            summary = val
        }
    }
}


open class PondAgent{
    var pondMDID: String?
    var agentMDID: String?
    var receiveNotifications: Bool = true
    var statusId: Int16?
    var rowID: Int32?
    var createDT: String?
    var mmodifyDT: String?
}
