//
//  FivePxConstants.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import Foundation

struct FivePxConstants {
    
    // MARK: General
    struct General {
        static let APIScheme = "https"
        static let APIHost = "api.500px.com"
        static let APIPath = "/v1/"
        static let APIEndpoint = FivePxConstants.General.APIScheme + "://" +
                                 FivePxConstants.General.APIHost   +
                                 FivePxConstants.General.APIPath
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Feature = "feature"
        static let ConsumerKey = "consumer_key"
        static let ImageSize = "image_size"
        static let Page = "page"
        static let NumberOfResults = "rpp" //cannot exceed 100
        static let ExcludeCategory = "exclude"
        static let IncludeOnlyOfCategory = "only"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        
        struct Feature {
            
            static let Popular = "popular"
            static let HighestRated = "highest_rated"
            static let Upcoming = "upcoming"
            static let EditorsChoice = "editors"
            static let FreshToday = "fresh_today"
            static let FreshYesterday = "fresh_yesterday"
            static let FreshWeek = "fresh_week"
        }
        
        struct ImageSize {
            
            //Cropped
            static let Square70 = "1"
            static let Square140 = "2"
            static let Square280 = "3"
            
            static let Square100 = "100"
            static let Square200 = "200"
            static let Square440 = "440"
            static let Square600 = "600"
            
            //Uncropped
            static let LongestEdge256 = "30"
            static let LongestEdge900 = "4"
            static let LongestEdge1080 = "1080"
            static let LongestEdge1600 = "1600"
            static let LongestEdge2048 = "2048"
            
            static let Height1080 = "6"
        }
        
        struct Categories {
            static let Nude = "4"
            static let People = "7"
            static let Uncategorized = "0"
        }
        //static let APIKey = "YOUR API KEY HERE" /* uncomment this and enter your API key */
        static let consumerKey = DeveloperParameters.consumerKey /* comment this out if you entered your API key above */
    }
    
    // MARK: JSON Response Keys
    struct ResponseKeys {
        
        static let Feature = "feature"
        static let Filters = "filters"
        static let CurrentPage = "current_page"
        static let TotalPages = "total_pages"
        static let TotalItems = "total_items"
        static let Photos = "photos"
    }
}