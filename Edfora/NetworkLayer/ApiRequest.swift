//
//  ApiRequest.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation

class ApiRequest {
    
    public static func makeGetRequest(urlPath: String, completionHandler:@escaping (Any) -> ()) {
        
        if urlPath.isEmpty {
            return
        }
        
        let url = NSURL(string: urlPath)
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers)
                completionHandler(jsonResult)
            } catch {
                
                let userInfo: [AnyHashable : Any] =
                    [NSLocalizedDescriptionKey :  NSLocalizedString("Network Error", value: "JSONSerialization fails", comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Network Error", value: "JSONSerialization fails", comment: "")]
                let error = NSError(domain: "HttpResponseErrorDomain", code: 401, userInfo: userInfo)
                completionHandler(error)
            }
        }
        task.resume()
        
    }
    
    public static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}


