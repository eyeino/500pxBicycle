//
//  FivePxPost.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import Foundation
import Freddy

public struct FivePxPost {
    //public let title: String
    public let id: Int
    public let name: String
//    public let rating: Double
    public let thumbnailUrl: String
    public let imageUrl: String
    public let username: String
//    public let city: String?
//    public let country: String?
}

//JSONDecodable is a necessary protocol for Freddy (JSON parser framework)
extension FivePxPost: JSONDecodable {
    public init(json value: JSON) throws {
        id = try value.getInt(at: "id")
        name = try value.getString(at: "name")
//        rating = try value.double("rating")
        thumbnailUrl = try value.getString(at: "images", 1, "https_url")
        imageUrl = try value.getString(at: "images", 0, "https_url")
        username = try value.getString(at: "user", "username")
//        city = try value.string("user", "city")
//        country = try value.string("user", "city")
    }
}
