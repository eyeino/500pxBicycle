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
    var totalPages: Int?
    var totalItems: Int?
    
    func getPostsWithFeature(feature: String, page: Int? = nil, completionHandlerForGetImages: (success: Bool, error: NSError?) -> Void) {
        
        var methodParameters = [
            FivePxConstants.ParameterKeys.Feature: feature,
            FivePxConstants.ParameterKeys.ConsumerKey: FivePxConstants.ParameterValues.consumerKey,
            FivePxConstants.ParameterKeys.ImageSize: FivePxConstants.ParameterValues.ImageSize.Square200 + "," + FivePxConstants.ParameterValues.ImageSize.LongestEdge900
        ]
        
        if let page = page {
            methodParameters[FivePxConstants.ParameterKeys.Page] = String(page)
        }
        
        let url = FivePxURLFromParameters(methodParameters, withPathExtension: "photos")
        let mutableRequest = NSMutableURLRequest(URL: url)
        mutableRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        setNetworkActivityIndicator(true)
        
        Alamofire.request(.GET, mutableRequest)
        .validate()
        .responseJSON { (response) in
            switch(response.result) {
            case .Success:
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        let posts = try json.array(FivePxConstants.ResponseKeys.Photos).map(FivePxPost.init)
                        self.totalPages = try json.int(FivePxConstants.ResponseKeys.TotalPages)
                        self.totalPages = try json.int(FivePxConstants.ResponseKeys.TotalItems)
                        
                        self.fivePxPosts = posts
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: true, error: nil)
                    } catch JSON.Error.IndexOutOfBounds(let badIndex) {
                        print("Index out of bounds: \(badIndex)")
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: false, error: nil)
                    } catch JSON.Error.KeyNotFound(let badKey) {
                        print("Key not found: \(badKey)")
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: false, error: nil)
                    } catch JSON.Error.UnexpectedSubscript(let badSubscript) {
                        print("Unexpected subscript: \(badSubscript)")
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: false, error: nil)
                    } catch JSON.Error.ValueNotConvertible(let badValue) {
                        print("Value not convertible: \(badValue)")
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: false, error: nil)
                    } catch {
                        print("Error with parsing JSON... (getImages)")
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(success: false, error: nil)
                    }
                }
            case .Failure:
                self.setNetworkActivityIndicator(false)
                completionHandlerForGetImages(success: false, error: response.result.error)
            }
        }
    }
    
    func loadImageToImageViewWithURL(url: URLStringConvertible, imageView: UIImageView, completionHandlerForLoadImageView: (success: Bool, error: NSError?, data: NSData?) -> Void) {
        setNetworkActivityIndicator(true)
        Alamofire.request(.GET, url)
        .validate()
        .responseData(completionHandler: { response in
            switch(response.result) {
            case .Success:
                if let data = response.data {
                    if let image = UIImage(data: data) {
                        imageView.image = image
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForLoadImageView(success: true, error: nil, data: data)
                    }
                }
                self.setNetworkActivityIndicator(false)
            case .Failure:
                self.setNetworkActivityIndicator(false)
                completionHandlerForLoadImageView(success: false, error: response.result.error, data: nil)
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
    
    private func setNetworkActivityIndicator(enabled: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = enabled
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