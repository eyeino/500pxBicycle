//
//  RealmClient.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import RealmSwift

class RealmClient: NSObject {
    
    func saveImage(toID: Int) {
        
    }
    
    func isSaved() -> Bool {
        return false
    }
    
    func loadImage(fromID: Int) {
        
    }
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> RealmClient {
        struct Singleton {
            static var sharedInstance = RealmClient()
        }
        return Singleton.sharedInstance
    }
}