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
    
    func getPostsWithFeature(_ feature: String, page: Int? = nil, allowNSFW: Bool, completionHandlerForGetImages: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        var methodParameters = [
            FivePxConstants.ParameterKeys.Feature: feature,
            FivePxConstants.ParameterKeys.ConsumerKey: FivePxConstants.ParameterValues.consumerKey,
            FivePxConstants.ParameterKeys.ImageSize: FivePxConstants.ParameterValues.ImageSize.Square200 + "," + FivePxConstants.ParameterValues.ImageSize.LongestEdge900
        ]
        
        if let page = page {
            methodParameters[FivePxConstants.ParameterKeys.Page] = String(page)
        }
        
        if allowNSFW == false {
            methodParameters[FivePxConstants.ParameterKeys.ExcludeCategory] = FivePxConstants.ParameterValues.Categories.Nude + "," +
            FivePxConstants.ParameterValues.Categories.People + "," +
            FivePxConstants.ParameterValues.Categories.Uncategorized
        }
        
        let url = FivePxURLFromParameters(methodParameters as [String : AnyObject], withPathExtension: "photos")
        let mutableRequest = NSMutableURLRequest(url: url)
        mutableRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        setNetworkActivityIndicator(true)
        
        Alamofire.request(url)
        .validate()
        .responseJSON { (response) in
            switch(response.result) {
            case .success:
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        let posts = try json.getArray(at: FivePxConstants.ResponseKeys.Photos).map(FivePxPost.init)
                        self.totalPages = try json.getInt(at: FivePxConstants.ResponseKeys.TotalPages)
                        self.totalPages = try json.getInt(at: FivePxConstants.ResponseKeys.TotalItems)
                        
                        self.fivePxPosts = posts
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForGetImages(true, nil)
                    } catch {
                        
                    }
                }
            case .failure:
                self.setNetworkActivityIndicator(false)
                completionHandlerForGetImages(false, response.result.error)
            }
        }
    }
    
    func loadImageToImageViewWithURL(_ url: URLConvertible, imageView: UIImageView, completionHandlerForLoadImageView: @escaping (_ success: Bool, _ error: Error?, _ data: Data?) -> Void) {
        setNetworkActivityIndicator(true)
        Alamofire.request(url)
        .validate()
        .responseData(completionHandler: { response in
            switch(response.result) {
            case .success:
                if let data = response.data {
                    if let image = UIImage(data: data) {
                        imageView.image = image
                        self.setNetworkActivityIndicator(false)
                        completionHandlerForLoadImageView(true, nil, data)
                    }
                }
                self.setNetworkActivityIndicator(false)
            case .failure:
                self.setNetworkActivityIndicator(false)
                completionHandlerForLoadImageView(false, response.result.error, nil)
            }
        })
    }


    // create a URL from parameters
    fileprivate func FivePxURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = FivePxConstants.General.APIScheme
        components.host = FivePxConstants.General.APIHost
        components.path = FivePxConstants.General.APIPath + (withPathExtension ?? "")
        
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
        }
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    fileprivate func FivePxURL() -> URL {
        
        var components = URLComponents()
        components.scheme = FivePxConstants.General.APIScheme
        components.host = FivePxConstants.General.APIHost
        components.path = FivePxConstants.General.APIPath
        
        return components.url!
    }
    
    fileprivate func setNetworkActivityIndicator(_ enabled: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = enabled
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
