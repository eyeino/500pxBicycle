//
//  500pxClient.swift
//  500pxBicycle
//
//  Created by Ian MacFarlane on 9/5/16.
//  Copyright © 2016 Ian MacFarlane. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

class FivePxClient: NSObject {
    
    var fivePxPosts = [FivePxPost]()
    
    func getPostsWithFeature(feature: String, completionHandlerForGetImages: (success: Bool, error: NSError?) -> Void) {
        
        let methodParameters = [
            FivePxConstants.ParameterKeys.Feature: feature,
            FivePxConstants.ParameterKeys.ConsumerKey: FivePxConstants.ParameterValues.consumerKey,
            FivePxConstants.ParameterKeys.ImageSize: FivePxConstants.ParameterValues.ImageSize.Square440
        ]
        
        let url = FivePxURLFromParameters(methodParameters, withPathExtension: "photos")
        
        Alamofire.request(.GET, url)
        .validate()
        .responseJSON { (response) in
            switch(response.result) {
            case .Success:
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        let posts = try json.array(FivePxConstants.ResponseKeys.Photos).map(FivePxPost.init)
                        self.fivePxPosts = posts
                        completionHandlerForGetImages(success: true, error: nil)
                        
                    } catch {
                        print("Error with parsing JSON... (getImages)")
                        completionHandlerForGetImages(success: false, error: nil)
                    }
                }
            case .Failure:
                print(response.result.error)
                completionHandlerForGetImages(success: false, error: nil)
            }
        }
    }
    
    func loadImageToImageViewWithURL(url: URLStringConvertible, imageView: UIImageView, completionHandlerForLoadImageView: (success: Bool, error: NSError?) -> Void) {
        Alamofire.request(.GET, url)
        .validate()
        .responseData(completionHandler: { response in
            switch(response.result) {
            case .Success:
                if let data = response.data {
                    if let image = UIImage(data: data) {
                        imageView.image = image
                        completionHandlerForLoadImageView(success: true, error: nil)
                    }
                }
            case .Failure:
                completionHandlerForLoadImageView(success: false, error: nil)
            }
        })
    }


    // create a URL from parameters
    private func FivePxURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = FivePxConstants.General.APIScheme
        components.host = FivePxConstants.General.APIHost
        components.path = FivePxConstants.General.APIPath + (withPathExtension ?? "")
        
        if !parameters.isEmpty {
            components.queryItems = [NSURLQueryItem]()
        }
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func FivePxURL() -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = FivePxConstants.General.APIScheme
        components.host = FivePxConstants.General.APIHost
        components.path = FivePxConstants.General.APIPath
        
        return components.URL!
    }
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> FivePxClient {
        struct Singleton {
            static var sharedInstance = FivePxClient()
        }
        return Singleton.sharedInstance
    }
}