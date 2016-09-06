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
    
    func saveThumbnailData(withId id: Int, data: NSData, title: String) {
        let newObject = FivePxImage()
        newObject.thumbnailData = data
        newObject.id = id
        newObject.title = title
        
        try! realm.write({
            realm.add(newObject)
        })
    }
    
    func updateImageData(withId id: Int, data: NSData) {
        if let object = realm.objects(FivePxImage.self).filter("id == \(id)").first {
            try! realm.write({
                object.imageData = data
            })
        }
    }
    
    func getThumbnailImage(fromID id: Int) -> UIImage? {
        let dataFromObject = realm.objects(FivePxImage.self).filter("id == \(id)").first?.thumbnailData
        if let data = dataFromObject {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
    func getBigImage(fromID id: Int) -> UIImage? {
        let dataFromObject = realm.objects(FivePxImage.self).filter("id == \(id)").first?.imageData
        if let data = dataFromObject {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
    func idsWithBigImages() -> [Int] {
        let objects = realm.objects(FivePxImage.self).filter("imageData != nil")
        var array = [Int]()
        for object in objects {
            array.append(object.id)
        }
        return array
    }
    
    func titlesWithBigImages() -> [String] {
        let objects = realm.objects(FivePxImage.self).filter("imageData != nil")
        var array = [String]()
        for object in objects {
            if let title = object.title {
                array.append(title)
            }
        }
        return array
    }
    
    func purgeImageFromRealm(withId id: Int) {
        let object = realm.objects(FivePxImage.self).filter("id == \(id)")
        
        try! realm.write({ 
            realm.delete(object)
        })
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