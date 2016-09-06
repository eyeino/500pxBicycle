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
    public let rating: Double
    public let imageUrl: String
    public let username: String
    public let city: String?
    public let country: String?
}

//JSONDecodable is a necessary protocol for Freddy (JSON parser framework)
extension FivePxPost: JSONDecodable {
    public init(json value: JSON) throws {
        id = try value.int("id")
        name = try value.string("name")
        rating = try value.double("rating")
        imageUrl = try value.string("images", 0, "https_url")
        username = try value.string("user", "username")
        city = try value.string("user", "city")
        country = try value.string("user", "city")
    }
}