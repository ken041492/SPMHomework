//
//  UserPreferences.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/3.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    let userPreference: UserDefaults
    
    private init() {
        userPreference = UserDefaults.standard
    }
    
    enum UserPreference: String {
        
        case JwtToken
    }
    
    var jwtToken: String {
        get { return userPreference.string(forKey: UserPreference.JwtToken.rawValue) ?? "" }
        set { userPreference.set(newValue, forKey: UserPreference.JwtToken.rawValue)}
    }
}
