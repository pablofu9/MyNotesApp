//
//  UserDefaults.swift
//  MyNotesApp
//
//  Created by Pablo Fuertes on 22/10/24.
//

//
//  UserDefaults+Utils.swift
//  GuaguasLPA
//
//  Created by Carlos Gutiérrez  on 27/3/23.
//

import Foundation

// MARK: - Custom objects

extension UserDefaults {

    /// Check for user defaults key existence
    /// - Parameter key: Key to check
    /// - Returns: <code>True</code> if the key exists or <code>false</code> in other case
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    /// Set Codable object into UserDefaults or remove it if object is nil
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    public func set<T: Codable>(object: T?, forKey: String) {
        guard let object = object else {
            removeObject(forKey: forKey)
            
            synchronize()
            
            return
        }
        
        let jsonData = try! JSONEncoder().encode(object)

        set(jsonData, forKey: forKey)
        
        synchronize()
    }

    /// Get Codable object from UserDefaults
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    
    
    /// Get Codable object from UserDefaults
    /// - Parameters:
    ///   - objectType: Codable Object
    ///   - forKey: Key string
    /// - Returns: The object if it exists or nil in other case
    public func get<T: Codable>(objectType: T.Type, forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }

        return try! JSONDecoder().decode(objectType, from: result)
    }
    
    /// Attempts to decode and if fails, removes the object for the given key
      /// - Parameters:
      ///   - objectType: The expected Codable object type
      ///   - forKey: The key under which the object is stored
      /// - Returns: The object if it can be decoded, or nil if it doesn't exist or fails to decode
      public func safeGet<T: Codable>(objectType: T.Type, forKey: String) -> T? {
          guard let data = value(forKey: forKey) as? Data else {
              return nil
          }
          
          do {
              let object = try JSONDecoder().decode(objectType, from: data)
              return object
          } catch {
              removeObject(forKey: forKey)
              synchronize()
              return nil
          }
      }
}

// MARK: - OnBoarding
extension UserDefaults {
    struct UserDefaultsOnBoardingKeys {
        static let kOnBoardingShown = "OnBoardingShown"
    }
    
    // MARK: - OnBoarding shown
    var onBoardingShown: Bool {
        get{
            guard let onBoardingShown = get(objectType: Bool.self, forKey: UserDefaultsOnBoardingKeys.kOnBoardingShown) else { return false }
            return onBoardingShown
        }
        
        set {
            set(object: newValue, forKey: UserDefaultsOnBoardingKeys.kOnBoardingShown)
            
            synchronize()
        }
    }
}
