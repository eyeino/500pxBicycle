//
//  FivePxImage.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/6/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import RealmSwift

class FivePxImage: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var thumbnailData: NSData?
    @objc dynamic var imageData: NSData?
    @objc dynamic var title: String?
}
