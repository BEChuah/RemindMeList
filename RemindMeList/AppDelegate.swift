//
//  AppDelegate.swift
//  RemindMeList
//
//  Created by Beng Ee Chuah on 30/01/2019.
//  Copyright © 2019 Beng Ee. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        do {
          _ = try Realm()
            
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }   
}





