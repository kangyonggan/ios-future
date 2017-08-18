//
//  HttpUtil.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation
import Just;

class HttpUtil: NSObject {
    
    // post请求
    static func sendPost(url: String, params: [String:String]) -> (Bool, String, NSDictionary?) {
        var res: (Bool, String, NSDictionary?);
        res.0 = false;
        
        let result = Just.post(url, data: params);
        
        if result.ok {
            let response = result.json as! NSDictionary;
            let respCo = response["respCo"] as! String;
            let respMsg = response["respMsg"] as! String;
            
            if respCo == "0000" {
                res.0 = true;
            }
            res.1 = respMsg;
            res.2 = response;
        } else {
            res.1 = "通讯异常，请稍后再试";
            res.2 = nil;
        }
        
        return res;
    }
    
    // post请求
    static func sendPost(url: String) -> (Bool, String, NSDictionary?) {
        var res: (Bool, String, NSDictionary?);
        res.0 = false;
        
        let result = Just.post(url);
        
        if result.ok {
            let response = result.json as! NSDictionary;
            let respCo = response["respCo"] as! String;
            let respMsg = response["respMsg"] as! String;
            
            if respCo == "0000" {
                res.0 = true;
            }
            res.1 = respMsg;
            res.2 = response;
        } else {
            res.1 = "通讯异常，请稍后再试";
            res.2 = nil;
        }
        
        return res;
    }
}
