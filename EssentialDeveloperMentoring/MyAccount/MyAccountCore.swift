//
//  MyAccountCore.swift
//
//  Created by _ on 5/27/15.
//

import Foundation

fileprivate let ACCOUNT_FIRST_LAUNCH_KEY =          "firstLaunch"
fileprivate let ACCOUNT_CELL_PHONE_KEY =            "cellPhone"
fileprivate let ACCOUNT_EMAIL_KEY =                 "email"
fileprivate let ACCOUNT_DOMAIN_KEY =                "domain"
fileprivate let ACCOUNT_FIRST_NAME_KEY =            "firstName"
fileprivate let ACCOUNT_FOCUSED_ORGANIZER_DID_KEY = "focusedOrganizerDID"
fileprivate let ACCOUNT_GKDID_KEY =                 "gkdid"
fileprivate let ACCOUNT_LAST_NAME_KEY =             "lastName"
fileprivate let ACCOUNT_NAME_KEY =                  "name"
fileprivate let ACCOUNT_PHOTO_LOCATION_KEY =        "photoLocation"
fileprivate let ACCOUNT_FAVORITE_CITY_KEY =         "favoriteCity"
fileprivate let ACCOUNT_USERDID_KEY =               "userDID"
fileprivate let ACCOUNT_MDID_KEY =                  "mdid"
fileprivate let ACCOUNT_KEYCHAIN_ACCESS_GROUP =     "accountKeychainAccessGroup"
fileprivate let ACCOUNT_DOMAINS_KEY =               "domains"
fileprivate let ACCOUNT_START_LAT =                 "startLat"
fileprivate let ACCOUNT_START_LONG =                "startLong"

public protocol MyAccountCore: AnyObject {
    func updateWithDictionary(_ dict : JSONDictionary)
    func updateWithFullDictionary(_ dict : JSONDictionary)
    func logout()
    
    var loggedIn : Bool {get}
    var cellPhone : String {get set}
    var domain : String {get set}
    var email : String {get set}
    var firstName : String {get set}
    var lastName : String {get set}
    var name : String {get set}
    var gkdid : String {get set}
    var userDID : String {get set}
    var mdid : String {get set}
    var focusedOrganizerDID : String {get set}
    var photoLocation : String {get set}
    var favoriteCity : String {get set}
    
    func setDefaults()
}

public class MyAccountBase : MyAccountCore {
    public static var sharedInstance: MyAccountBase = MyAccountBase()
}

extension MyAccountCore {
    
    public var loggedIn : Bool{
        return !gkdid.isEmpty && !userDID.isEmpty && !mdid.isEmpty
    }
    
    public var gkdid : String{
        get{
            gkdid
        }
        set(val){
            gkdid = val
        }
    }
    
    public var cellPhone : String {
        get {
            return self.get(ACCOUNT_CELL_PHONE_KEY)
        }
        set(val) {
            self.set(ACCOUNT_CELL_PHONE_KEY, value: val);
        }
    }
    
    public var domain : String{
        get {
            return self.get(ACCOUNT_DOMAIN_KEY)
        }
        set(val) {
            self.set(ACCOUNT_DOMAIN_KEY, value: val);
        }
    }
    
    public var email : String{
        get {
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
    
    public var lastName : String{
        get{
            return self.get(ACCOUNT_LAST_NAME_KEY)
        }
        set(val){
            self.set(ACCOUNT_LAST_NAME_KEY, value: val);
        }
    }
    
    public var focusedOrganizerDID : String{
        get{
            return self.get(ACCOUNT_FOCUSED_ORGANIZER_DID_KEY)
        }
        set(val){
            self.set(ACCOUNT_FOCUSED_ORGANIZER_DID_KEY, value: val);
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
    
    public var photoLocation : String{
        get{
            return self.get(ACCOUNT_PHOTO_LOCATION_KEY)
        }
        set(val){
            self.set(ACCOUNT_PHOTO_LOCATION_KEY, value: val);
        }
    }
    
    public var favoriteCity : String {
        get {
            return self.get(ACCOUNT_FAVORITE_CITY_KEY)
        }
        set(val) {
            self.set(ACCOUNT_FAVORITE_CITY_KEY, value: val)
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
    
    public var mdid : String{
        get{
            return self.get(ACCOUNT_MDID_KEY)
        }
        set(val){
            self.set(ACCOUNT_MDID_KEY, value: val);
        }
    }
    
    public var domains : [String] {
        get{
            return self.get(ACCOUNT_DOMAINS_KEY)
        }
        set(val){
            self.set(ACCOUNT_DOMAINS_KEY, value: val);
        }
    }
    
    //    public var startLat : Double{
    //        get {
    //            return self.get(ACCOUNT_START_LAT)
    //        }
    //        set(val){
    //            self.set(ACCOUNT_START_LAT, value: val)
    //        }
    //    }
    //
    //    public var startLong : Double{
    //        get {
    //            return self.get(ACCOUNT_START_LONG)
    //        }
    //        set(val){
    //            self.set(ACCOUNT_START_LONG, value: val)
    //        }
    //    }
    
    public func get(_ key: String) -> String{
        return (UserDefaults.standard.object(forKey: key) as? String) ?? ""
    }
    
    public func set(_ key: String, value: String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func get(_ key: String) -> [String]{
        return UserDefaults.standard.stringArray(forKey: key) ?? [String]()
    }
    
    public func set(_ key: String, value: [String]){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func get(_ key : String) -> Double{
        return UserDefaults.standard.object(forKey: key) as! Double
    }
    
    public func set(_ key : String, value : Double){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func setDefaults(){
        var userDefaultsDefaults: Dictionary = Dictionary<String, AnyObject>()
        userDefaultsDefaults[ACCOUNT_KEYCHAIN_ACCESS_GROUP] = "" as AnyObject?
        
        userDefaultsDefaults[ACCOUNT_FIRST_LAUNCH_KEY] = 1 as AnyObject?
        userDefaultsDefaults[ACCOUNT_CELL_PHONE_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_DOMAIN_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_EMAIL_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_FIRST_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_FOCUSED_ORGANIZER_DID_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_LAST_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_NAME_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_PHOTO_LOCATION_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_USERDID_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_MDID_KEY] = "" as AnyObject?
        userDefaultsDefaults[ACCOUNT_DOMAINS_KEY] = "" as AnyObject?
        UserDefaults.standard.register(defaults: userDefaultsDefaults)
    }
    
    public func logout(){
        cellPhone = ""
        domain = ""
//        email = ""
        firstName = ""
        focusedOrganizerDID = ""
        gkdid = ""
        lastName = ""
        name = ""
        photoLocation = ""
        favoriteCity = ""
        domains.removeAll()
        
        clearCookies()
    }
    
    public func clearCookies(){
        //clear alamofire cache/cookies
    }
    
    public func updateWithFullDictionary(_ dict : JSONDictionary){
        
        if let userInfo = dict["userInfo"] as? JSONDictionary{
            updateWithDictionary(userInfo)
        }
        if let domainsJson = dict["domains"] as? [String]{
            updateDomains(domainsJson)
        }
    }
    
    public func updateWithDictionary(_ dict: JSONDictionary) {
        if let val: String = dict["cellPhone"] as? String {
            cellPhone = val
        }
        if let val: String = dict["email"] as? String {
            email = val
        }
        if let val: String = dict["domainName"] as? String {
            domain = val
        }
        if let val: String = dict["firstName"] as? String {
            firstName = val
        }
        if let val: String = dict["focusedOrganizerDID"] as? String {
            focusedOrganizerDID = val
        }
        if let val: String = dict["gkdid"] as? String {
            gkdid = val
        }
        if let val: String = dict["lastName"] as? String {
            lastName = val
        }
        if let val: String = dict["name"] as? String {
            name = val
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
        if let val: String = dict["favoriteCity"] as? String {
            favoriteCity = val
        }
    }
    
    public func updateDomains(_ domainsJson: [String]){
        domains.removeAll()
        for domainName in domainsJson{
            domains.append(domainName)
        }
    }
    
}
