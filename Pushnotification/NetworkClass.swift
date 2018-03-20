//
//  NetworkClass.swift
//  Pushnotification
//
//  Created by ios on 18/11/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

public class A {
    //fileprivate is for (if both classes are in same file than fileprivate method is accessible)
    //private :  means only this class & in terms of class only in this swift file
    //final : you can not inherit this class.
    //internal : restricted to this module (i think its framework, can only be used in which framework it is created)
    
    
    fileprivate func someMethod() {}
    var myPrivate : String!
}

internal class B: A {
    override func someMethod() {
        super.someMethod()
        myPrivate = "Bhavin"
        
    }
}
class NetworkClass: NSObject {
    static let sharedInstance = NetworkClass()
    //Note :
    //@esacaping is mostly used when your completion has some delay like network call or timer etc.
    //@nonescaping is used when there is no delay in completion ex. calculation,condition check etc.
    // By default this closure are nonescaping
    override init() {
        print("I am initialized");
    }
    //Non escaping method
    public func nonescapingMethod(completion : (_ resp : Bool , _ denied : Int) -> Void){
        completion(false,4)
    }
    //Generic function for API calls
  public func getResponseForRequest(request: URLRequest , completion : @escaping (_ response : HTTPURLResponse? , _ error: Error? , _ json : AnyObject?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let resp = response as? HTTPURLResponse  else {
                print("Error occured")
                return
            }
            
            guard let dat = data else {
                completion(resp,error,nil)
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: dat, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                completion(resp,error,json)
            }
            catch {
                print("json error: \(error)")
                completion(resp,error,nil)
            }
            
        }
        task.resume()
    }
    
    
    //Request creation method
    func createRequestForURL(url : String) -> URLRequest {
        let reqUrl  = URL.init(string: url)
        var request = URLRequest.init(url: reqUrl!)
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        request.addValue("fdsbhfbshhsdhjs", forHTTPHeaderField:"device-identifier")
        request.addValue("ios", forHTTPHeaderField:"device-user-agent")
        
        return request
    }
    func createGETRequestForURL(url:String) -> URLRequest {
        var request = self.createRequestForURL(url: url)
        request.httpMethod = "GET"
        return request
    }
    func createPOSTRequestForURL(url:String) -> URLRequest {
        var request = self.createRequestForURL(url: url)
         request.httpMethod = "POST"
        return request
    }
    
}
