//
//  RealmClient.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import RealmSwift

class RealmClient: NSObject {
    
    let realm = try! Realm()
    
    func saveImageDataWithID(id: Int, data: NSData) {
        let newObject = FivePxImage()
        newObject.data = data
        newObject.id = id
        
        try! realm.write({
            realm.add(newObject)
        })
    }
    
    func getImage(fromID id: Int) -> UIImage? {
        let dataFromObject = realm.objects(FivePxImage.self).filter("id == \(id)").first?.data
        if let data = dataFromObject {
            if let image = UIImage(data: data) {
                return image
            }
        }
        
        return nil
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