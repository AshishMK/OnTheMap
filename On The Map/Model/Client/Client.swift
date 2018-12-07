//
//  Client.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
import UIKit
class Client {
    static let parseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    struct Auth {
        static var accountId = 0
        static var registrationKey = ""
        static var sessionId = ""
    }
    struct Account{
        static var firstName = ""
        static var lastName = ""
        static var address = ""
        static var longitude: Double = 0
        static var latitude:Double = 0
        static var mapString = ""
        static var objectID = ""
    }
    
    
    enum Endpoints {
        static let baseURLParse = "https://parse.udacity.com/parse/classes/StudentLocation"
        case getSession
        case studentLocations
        case getUserData
        case putLocation
        case studentLocation(String)
        
        var stringValue : String {
            switch self {
            case .getSession:
                return "https://onthemap-api.udacity.com/v1/session"
            case .studentLocations:
                return Endpoints.baseURLParse + "?limit=50&order=-updatedAt"
            case .studentLocation(let query):
                return Endpoints.baseURLParse + "?where=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .getUserData:
                return "https://onthemap-api.udacity.com/v1/users/\(Auth.registrationKey)"
            case .putLocation:
                return Endpoints.baseURLParse+"/\(Account.objectID)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void){
       taskForGETRequest(url: Endpoints.getUserData.url, responseType: UserDataResponse.self, true){
            (response,error)
            in
            if let response = response {
                Account.firstName = response.firstName
                Account.lastName = response.lastName
                Account.address = response.email.address
                completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }
    
    class func postUserLocation(mapString: String, mediaURL: String, latitude: Double, longitude : Double,completion: @escaping (Bool, Error?) -> Void){
        let body =  PostStudentLocation(uniqueKey: Auth.registrationKey, firstName: Account.firstName, lastName: Account.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoints.studentLocations.url, responseType: PostStudentLocationResponse.self, body: body, false){
            (response,error)
            in
            if let response = response {
                Account.objectID = response.objectId
                
                completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }
    
    class func putUserLocation(mapString: String, mediaURL: String, latitude: Double, longitude : Double,completion: @escaping (Bool, Error?) -> Void){
       print("\(Endpoints.putLocation.stringValue)")
        let body =  PostStudentLocation(uniqueKey: Auth.registrationKey, firstName: Account.firstName, lastName: Account.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPUTRequest(url: Endpoints.putLocation.url, responseType: PUTStudentLocationResponse.self, body: body){
            (response,error)
            in
            if response != nil {
               completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }
    
    
    class func getStudentLocation(completion: @escaping (Bool, Error?,UIActivityIndicatorView) -> Void,spinner: UIActivityIndicatorView){
      taskForGETRequest(url: Endpoints.studentLocation("{\"uniqueKey\":\"\(Auth.registrationKey)\"}").url, responseType: StudentLocationsResult.self, false){
            (response,error)
            in
            if let response = response {
                if  response.results.count > 0 {
                    Account.latitude = response.results[0].latitude
                    Account.longitude = response.results[0].longitude
                    Account.mapString = response.results[0].mapString
                }
                completion(true, nil,spinner)
            }
            else{
                completion(false, error,spinner)
            }
        }
        
    }
    
    class func getSession(userName : String, password : String, completion: @escaping (Bool, Error?) -> Void){
        let body = UdacityLoginRequest(udacity: LoginRequest(userName: userName, password: password))
        taskForPOSTRequest(url: Endpoints.getSession.url, responseType: LoginResponse.self, body: body, true){
            (response, error)
            in
            if let response = response {
                Auth.sessionId = response.session.sessionId
                Auth.registrationKey = response.account.registrationKey
                
                completion(true, nil)
            }
            else{
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation],Error?) -> Void){
        taskForGETRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationsResult.self,false, completion: {
            (response, error)
            in
            if let response = response {
                //filter the items with nil vaues
                completion(response.results.filter(){ $0.mediaURL != "" && $0.latitude != 0 && $0.longitude != 0 },nil)
            }
            else {
                completion([],error)
            }
            
        })
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,_ isUdacityApi: Bool, completion: @escaping (ResponseType?, Error?) -> Void)-> URLSessionTask{
        var request = URLRequest(url: url)
        request.addValue(parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if isUdacityApi{
                    let range = Range(5..<data.count)
                    data = data.subdata(in: range)
                }
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, _ isUdacityApi : Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        if isUdacityApi {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        let httpBody = try! JSONEncoder().encode(body)
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request){
            data,response,error
            in
            guard var data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                if isUdacityApi {
                    let range = Range(5..<data.count)
                    data = data.subdata(in: range)
                }
                let requestTokenResponse = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(requestTokenResponse,nil)
                }
            }catch{
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
            }
        }
        task.resume()
    }
    
    
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
     
        let httpBody = try! JSONEncoder().encode(body)
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request){
            data,response,error
            in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
               let requestTokenResponse = try decoder.decode(ResponseType.self, from: data)
               DispatchQueue.main.async {
                    completion(requestTokenResponse,nil)
                }
            }catch{
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
            }
        }
        task.resume()
    }
    
    class func logout(spinner: UIActivityIndicatorView ,completionHandler: @escaping (Bool,Error?,UIActivityIndicatorView)-> Void) {
        var request = URLRequest(url: Endpoints.getSession.url)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request){
            data,response,error
            in
            guard data != nil else{
                DispatchQueue.main.async {
                    completionHandler(false,error,spinner)
                }
                return
            }
            Auth.sessionId = ""
            Auth.registrationKey = ""
            
            Account.firstName = ""
            Account.lastName = ""
            Account.address = ""
            Account.longitude = 0
            Account.latitude = 0
            Account.mapString = ""
            Account.objectID = ""
            StudentLocationsData.locations = []
            DispatchQueue.main.async {
                completionHandler(true,nil,spinner)
            }
        }
        task.resume()
    }
}
