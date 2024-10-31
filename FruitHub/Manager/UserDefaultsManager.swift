//
//  UserDefaultsManager.swift
//  FruitHub
//
//  Created by Vlad on 31.10.24.
//

import Foundation

protocol AppLaunchChecking: AnyObject {
    func isNotFirstAppLaunch() -> Bool
}

protocol AppLaunchSetting: AnyObject {
    func setFirstAppLaunch()
}

final class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey: String = "firstLaunch"
}

//MARK: AppLaunchChecking
extension UserDefaultsManager: AppLaunchChecking {
    func isNotFirstAppLaunch() -> Bool {
        return userDefaults.bool(forKey: firstLaunchKey)
    }
}

//MARK: AppLaunchSetting
extension UserDefaultsManager: AppLaunchSetting {
    func setFirstAppLaunch() {
        userDefaults.set(true, forKey: firstLaunchKey)
    }
}
