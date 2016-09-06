//
//  FivePxImage.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/6/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import RealmSwift

class FivePxImage: Object {
    dynamic var id: Int = 0
    dynamic var thumbnailData: NSData?
    dynamic var imageData: NSData?
    dynamic var title: String?
}