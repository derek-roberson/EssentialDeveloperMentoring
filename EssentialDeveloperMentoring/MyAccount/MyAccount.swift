//
//  MyAccount.swift
//  
//
//  Created by _ on 8/7/15.
//

import Foundation
import CoreData

@objc public class MyAccount: NSObject, MyAccountCore {
    
    enum SecurityLevel: Int {
        case Agent = 10
        case Broker = 15
    }
    
    let ACCOUNT_CELL_PHONE_KEY =            "cellPhone"
    let ACCOUNT_EMAIL_KEY =                 "email"
    let ACCOUNT_DOMAIN_KEY =                "domain"
    let ACCOUNT_SUBDOMAIN_KEY =             "subdomain"
    let ACCOUNT_FIRST_NAME_KEY =            "firstName"
    let ACCOUNT_GKDID_KEY =                 "gkdid"
    let ACCOUNT_LAST_NAME_KEY =             "lastName"
    let ACCOUNT_NAME_KEY =                  "name"
    let ACCOUNT_USERDID_KEY =               "userDID"
    let ACCOUNT_MDID_KEY =                  "mdid"
    let ACCOUNT_SECURITY_LEVEL =            "securityLevel"
    let ACCOUNT_HAS_AINC =                  "hasAinc"
    let ACCOUNT_IS_ENTERPRISE =             "isEnterprise"
    let ACCOUNT_IS_LENDER =                 "isLender"
    let ACCOUNT_HOME_PHONE_KEY =            "homePhone"
    let ACCOUNT_OFFICE_PHONE_KEY =          "officePhone"
    let ACCOUNT_TITLE_KEY =                 "title"
    let ACCOUNT_LICENSE_NUMBER_KEY =        "licenseNumber"
    let ACCOUNT_DESCRIPTION_KEY =           "description"
    let ACCOUNT_PHOTO_URL_KEY =             "photoLocation"
    
    let ACCOUNT_HAS_DIALER =                "ACCOUNT_HAS_DIALER"
    let DIALER_DEFAULT_NUMBER =             "DIALER_DEFAULT_NUMBER"
    let DIALER_SELECTED_AUDIO =             "DIALER_SELECTED_AUDIO"
    let DIALER_SELECTED_AUDIO_UDID =        "DIALER_SELECTED_AUDIO_UDID"
    let PHONE_VERIFIED =                    "PHONE_VERIFIED"
    
    @objc var agentName: String = ""
    var password: String = ""
    
    public var photoLocation : String = ""
    var signature : String = ""
    var filterState : String = ""
    var securityLevelAsType : String = ""
    // this value is an enum based on Security Level. This was created because 'securityLevelAsType' does not always come back in response
    var securityType: SecurityLevel?
    
    var primaryMDID : String = ""
    var ddid : String = ""
    var productType : String = ""
    
    var onLeadAlertCall: Bool = false
    var leadAlertCallStartHour: Int = 0
    var leadAlertCallEndHour: Int = 0
    var lrAgentOverflow: String = ""
    
    var domains : [NSManagedObject]{
        get{
            return []
        }
    }
    var calendarAccounts : [CalendarAccount] = []
    
    @objc var teamLeader = false
    @objc var canAssign = false
    @objc var hasTrueText = false
    @objc var canEditLabel = false
    @objc var canAssignFromPond = false
    @objc var canVideoMessage = false
    @objc var canModifyAutotracks = false
    var agentPondAssignments : [PondAgent] = []

//    var keychain: Keychain
    
    @objc static let sharedInstance = MyAccount()
    
    fileprivate override init(){
        //

        super.init()
        setDefaults()
    }
    
    func updateWithDictionary(_ dict: NSDictionary, success : @escaping SuccessBlock) {
        if let userJson = dict["userInfo"] as? JSONDictionary{
            updateUserInfo(userJson as NSDictionary)
        }
        
        if let details = dict["details"] as? JSONDictionary{
            updateDetails(details as NSDictionary)
        }
        
        if let domainsJson = dict["domains"] as? [String]{
            MyAccount.sharedInstance.updateDomains(domainsJson, success: success)
        }
        
        if let siteInfo = dict["siteInfo"] as? JSONDictionary {
            // todo any additional extended info storage we need
            if let isEnterprise = siteInfo["isEnterprise"] as? Bool {
                self.isEnterprise = isEnterprise
            }
            if let isLender = siteInfo["isLenderSite"] as? Bool {
                self.isLender = isLender
            }
            if let val = siteInfo["primaryMDID"] as? String{
                self.primaryMDID = val
            }
            if let val = siteInfo["ddid"] as? String{
                self.ddid = val
            }
            if let val = siteInfo["productType"] as? String{
                self.productType = val
            }
            if let val = siteInfo["on_LeadAlertCall"] as? Bool {
                self.onLeadAlertCall = val
            }
            if let val = siteInfo["leadAlertCallStartHour"] as? Int {
                self.leadAlertCallStartHour = val
            }
            if let val = siteInfo["leadAlertCallEndHour"] as? Int {
                self.leadAlertCallEndHour = val
            }
            if let val = siteInfo["lR_AgentOverflow"] as? String {
                self.lrAgentOverflow = val
            }
        }
    }
    
    func updateDetails(_ dict : NSDictionary){
        if let value: Bool = dict["truetext"] as? Bool{
            hasTrueText = value
        }
        if let _ = dict["pipeline"] as? JSONArray{
            //
        }
        if let _ = dict["googletaskheaders"] as? JSONArray{
            //
        }
        if let _ = dict["googlecalenderheaders"] as? JSONArray{
            //
        }
        if let val: Bool = dict["onainc"] as? Bool{
            hasAinc = val
        }
    }
    
    func updateUserInfo(_ dict: NSDictionary){
        if let val: String = dict["cellPhone"] as? String {
            cellPhone = val
            if dialerDefaultNumber != "5555555555" {
                dialerDefaultNumber = cellDefaultNumberStr
            }
        }
        if let val: String = dict["email"] as? String {
            email = val
        }
        if let val: String = dict["domainName"] as? String {
            domain = val
        }
        if let val: String = dict["subdomain"] as? String {
            subdomain = val
        }
        if let val: String = dict["firstName"] as? String {
            firstName = val
        }

        if let val: String = dict["gkdid"] as? String {
            gkdid = val
        }
        if let val: String = dict["lastName"] as? String {
            lastName = val
        }
        if let val: String = dict["name"] as? String {
            name = val
            agentName = val
        }
        if let val: String = dict["photoLocation"] as? String {
            photoLocation = val
        }
        if let val: String = dict["userDID"] as? String {
            userDID = val
        }
        if let val: String = dict["mdid"] as? String {
            mdid = val
        }
        if let val: String = dict["messageSignature"] as? String {
            signature = val
        }
        if let val: String = dict["state"] as? String {
            filterState = val
        }
        
        if let val: Bool = dict["perm_VideoMessaging"] as? Bool {
            canVideoMessage = val
        }
        
        if let val: Bool = dict["user_IsTeamLeader"] as? Bool {
            teamLeader = val
        }
        if let val: Bool = dict["user_CanAssignLeads"] as? Bool {
            canAssign = val
        }
        if let val: Bool = dict["user_CanAssignFromPond"] as? Bool {
            canAssignFromPond = val
        }
        if let pondAssignments = dict["agentPondAssignments"] as? JSONArray{
            parsePondAgentsResponse(pondAssignments)
        }
        if let val: Int = dict["securityLevel"] as? Int {
            securityLevel = val
        }
        if let val: Bool = dict["hasAinc"] as? Bool {
            hasAinc = val
        }
        if let val: Bool = dict["onDialer"] as? Bool {
            hasDialer = val
            if val && MyAccount.sharedInstance.dialerDefaultNumber == "" {
                MyAccount.sharedInstance.dialerDefaultNumber = MyAccount.sharedInstance.cellDefaultNumberStr
            }
        }
        if let val: Bool = dict["user_CanEditLabels"] as? Bool{
            canEditLabel = val
        }
        if let val : String = dict["securityLevelAsType"] as? String{
            securityLevelAsType = val
        }
        
        if let val = dict["perm_Plips"] as? Bool {
            canModifyAutotracks = val
        }
    }
    
    func updateExtendedInfo(_ dict: JSONDictionary) {
        if let val: String = dict[ACCOUNT_HOME_PHONE_KEY] as? String {
            homePhone = val
        }
        if let val: String = dict[ACCOUNT_OFFICE_PHONE_KEY] as? String {
            officePhone = val
        }
        if let val: String = dict[ACCOUNT_TITLE_KEY] as? String {
            title = val
        }
        if let val: String = dict[ACCOUNT_LICENSE_NUMBER_KEY] as? String {
            licenseNumber = val
        }
        if let val: String = dict[ACCOUNT_DESCRIPTION_KEY] as? String {
            biography = val
        }
        if let val: String = dict[ACCOUNT_PHOTO_URL_KEY] as? String {
            photoUrl = val
        }
    }
    
    func parsePondAgentsResponse(_ response : JSONArray) {
        agentPondAssignments.removeAll()
        if response.count != 0 {
            for dict in response {
                let pa = PondAgent()
                if let val = dict["pondMDID"] as? String{
                    pa.pondMDID = val
                }
                if let val = dict["agentMDID"] as? String{
                    pa.agentMDID = val
                }
                if let val = dict["receiveNotifications"] as? Bool{
                    pa.receiveNotifications = val
                }
                if let val = dict["statusId"] as? Int16{
                    pa.statusId = val
                }
                if let val = dict["rowID"] as? Int32{
                    pa.rowID = val
                }
                if let val = dict["createDT"] as? String{
                    pa.createDT = val
                }
                if let val = dict["modifyDT"] as? String{
                    pa.mmodifyDT = val
                }
                agentPondAssignments.append(pa)
            }
        }
    }
    
    func updateDomains(_ domainsJson: [String], success : @escaping SuccessBlock){
        success()
    }
    
    func fetchCalendars(){
        if !mdid.isEmpty{
            //
        }
    }
    
    public func logout(){
//        email = ""
        agentName = ""
        password = ""
        
        cellPhone  = ""
        firstName  = ""
        lastName  = ""
        name  = ""
        
        photoLocation  = ""
        signature  = ""
        filterState  = ""
        
        userDID  = ""
        mdid = ""
        gkdid = ""
        domain = ""
//        CincDomain.MR_TruncateAll()
        calendarAccounts = []
        securityLevel = 1
        
        teamLeader = false
        canAssign = false
        hasTrueText = false
        hasAinc = false
        
        hasDialer = false
        isLender = false
        dialerDefaultNumber = ""
        dialerSelectedAudio = ""
        dialerSelectedAudioUDID = ""
        
        clearCookies()
    }
    
    var signedIn : Bool{
        get{
            if !gkdid.isEmpty && !mdid.isEmpty && !domain.isEmpty{
                return true
            }
            
            //Reset these since something is off
            gkdid = ""
            mdid = ""
            domain = ""
            return false
        }
    }
    
    @objc public var cellPhone : String{
        get{
            return self.get(ACCOUNT_CELL_PHONE_KEY)
        }
        set(val) {
            self.set(ACCOUNT_CELL_PHONE_KEY, value: val);
        }
    }
    
    @objc public var homePhone: String {
        get {
            return self.get(ACCOUNT_HOME_PHONE_KEY)
        }
        set(val) {
            self.set(ACCOUNT_HOME_PHONE_KEY, value: val)
        }
    }
    
    @objc public var officePhone: String {
        get {
            return self.get(ACCOUNT_OFFICE_PHONE_KEY)
        }
        set(val) {
            self.set(ACCOUNT_OFFICE_PHONE_KEY, value: val)
        }
    }
    
    @objc public var domain : String{
        get{
            return self.get(ACCOUNT_DOMAIN_KEY)
        }
        set(val){
            self.set(ACCOUNT_DOMAIN_KEY, value: val);
        }
    }
    
    @objc public var subdomain: String {
        get {
            return self.get(ACCOUNT_SUBDOMAIN_KEY)
        }
        set(val) {
            self.set(ACCOUNT_SUBDOMAIN_KEY, value: val)
        }
    }
    
    
    @objc public var email : String{
        get{
            return self.get(ACCOUNT_EMAIL_KEY)
        }
        set(val){
            self.set(ACCOUNT_EMAIL_KEY, value: val);
        }
    }

    public var firstName : String{
        get{
            return self.get(ACCOUNT_FIRST_NAME_KEY)
        }
        set(val){
            self.set(ACCOUNT_FIRST_NAME_KEY, value: val);
        }
    }
    
    
    @objc public var gkdid : String = ""
    
    @objc public var isEnterprise: Bool {
        get {
            return self.getBool(ACCOUNT_IS_ENTERPRISE)
        }
        set(val) {
            self.setBool(ACCOUNT_IS_ENTERPRISE, value: val)
        }
    }
    
    @objc public var isLender : Bool {
        get {
            return self.getBool(ACCOUNT_IS_LENDER)
        }
        set(val) {
            self.setBool(ACCOUNT_IS_LENDER, value: val)
        }
    }
    
    public var lastName : String{
        get{
            return self.get(ACCOUNT_LAST_NAME_KEY)
        }
        set(val){
            self.set(ACCOUNT_LAST_NAME_KEY, value: val);
        }
    }
    
    public var name : String{
        get{
            return self.get(ACCOUNT_NAME_KEY)
        }
        set(val){
            self.set(ACCOUNT_NAME_KEY, value: val);
        }
    }
    

    
    public var userDID : String{
        get{
            return self.get(ACCOUNT_USERDID_KEY)
        }
        set(val){
            self.set(ACCOUNT_USERDID_KEY, value: val);
        }
    }
    
    @objc public var mdid : String{
        get{
            return self.get(ACCOUNT_MDID_KEY)
        }
        set(val){
            self.set(ACCOUNT_MDID_KEY, value: val);
            fetchCalendars()
        }
    }
    
    @objc var securityLevel : Int {
        get{
            return self.getInt(ACCOUNT_SECURITY_LEVEL)
        }
        set(val){
            self.setInt(ACCOUNT_SECURITY_LEVEL, value: val)
            self.securityType = SecurityLevel(rawValue: val)
        }
    }
    
    var hasAinc : Bool {
        get{
            return self.getBool(ACCOUNT_HAS_AINC)
        }
        set(val){
            self.setBool(ACCOUNT_HAS_AINC, value: val);
        }
    }
    
    var hasDialer: Bool {
        get {
            return self.getBool(ACCOUNT_HAS_DIALER)
        }
        set(val) {
            self.setBool(ACCOUNT_HAS_DIALER, value: val)
        }
    }
    
    var dialerDefaultNumber: String {
        get {
            return self.get(DIALER_DEFAULT_NUMBER)
        }
        set(val) {
            self.set(DIALER_DEFAULT_NUMBER, value: val)
        }
    }
    
    var dialerSelectedAudio: String {
        get {
            return self.get(DIALER_SELECTED_AUDIO)
        }
        set(val) {
            self.set(DIALER_SELECTED_AUDIO, value: val)
        }
    }
    
    var dialerSelectedAudioUDID: String {
        get {
            return self.get(DIALER_SELECTED_AUDIO_UDID)
        }
        set(val) {
            self.set(DIALER_SELECTED_AUDIO_UDID, value: val)
        }
    }
    
    var phoneVerified : Bool{
        get {
            return self.getBool(PHONE_VERIFIED)
        }
        set(val){
            self.setBool(PHONE_VERIFIED, value: val)
        }
    }
    
    var title: String {
        get {
            return self.get(ACCOUNT_TITLE_KEY)
        }
        set(val) {
            self.set(ACCOUNT_TITLE_KEY, value: val)
        }
    }
    
    var licenseNumber: String {
        get {
            return self.get(ACCOUNT_LICENSE_NUMBER_KEY)
        }
        set(val) {
            self.set(ACCOUNT_LICENSE_NUMBER_KEY, value: val)
        }
    }
    
    var biography: String {
        get {
            return self.get(ACCOUNT_DESCRIPTION_KEY)
        }
        set(val) {
            self.set(ACCOUNT_DESCRIPTION_KEY, value: val)
        }
    }
    
    // if this is empty, agent has no photo set
    var photoUrl: String {
        get {
            return self.get(ACCOUNT_PHOTO_URL_KEY)
        }
        set(val) {
            self.set(ACCOUNT_PHOTO_URL_KEY, value: val)
        }
    }
    
    var cellDefaultNumberStr: String{
        return "\(cellPhone) (Cell)(Default)"
    }
    
    func get(_ key: String) -> String{
        return UserDefaults.standard.object(forKey: key) as! String
    }
    
    func set(_ key: String, value: String){
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getInt(_ key: String) -> Int {
        guard UserDefaults.standard.object(forKey: key) != nil else {
            return -1
        }
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func setInt(_ key: String, value: Int) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getBool(_ key: String) -> Bool {
        guard UserDefaults.standard.object(forKey: key) != nil else {
            return false
        }
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setBool(_ key: String, value: Bool) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func setDefaults(){
        var userDefaultsDefaults: Dictionary = Dictionary<String, AnyObject>()
        userDefaultsDefaults[ACCOUNT_CELL_PHONE_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_DOMAIN_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_EMAIL_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_FIRST_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_LAST_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_USERDID_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_MDID_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_SECURITY_LEVEL] = -1 as AnyObject?
        userDefaultsDefaults[ACCOUNT_HAS_AINC] = false as AnyObject?
        userDefaultsDefaults[ACCOUNT_HAS_DIALER] = false as AnyObject?
        userDefaultsDefaults[DIALER_DEFAULT_NUMBER] = "" as AnyObject?
        userDefaultsDefaults[DIALER_SELECTED_AUDIO] = "" as AnyObject?
        userDefaultsDefaults[DIALER_SELECTED_AUDIO_UDID] = "" as AnyObject?
        UserDefaults.standard.register(defaults: userDefaultsDefaults)
    }
    
    func getAccountRole() -> String {
        if securityType == .Agent {
            return "Agent"
        } else {
            return "Broker"
        }
    }
}
