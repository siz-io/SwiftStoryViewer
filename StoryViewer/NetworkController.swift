//
//  NetworkController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 02/04/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import Foundation

struct NetworkController {
    
    typealias Token = String
    
    private static let queue = NSOperationQueue()
    private static let endpoint = "http://api.dev.siz.io"
    
    private static func toJson(#dictionary: NSDictionary) -> NSData? {
        var err: NSError?
        if let result =  NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: &err) {
            return result
        } else {
            println("Json serialization error = \(err)")
        }
        return .None
    }
    
    private static func fromJson(data: NSData) -> NSDictionary? {
        var err: NSError?
        if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            return dictionary
        } else {
            println("Json deserialization error = \(err)")
        }
        return .None
    }
    
    private static func sendRequest(path: String, method: String = "GET", data httpBody: NSDictionary? = .None, accessToken: Token? = .None, onSuccess: (NSURLResponse,NSDictionary) -> Void){
        if let url = NSURL(string: "\(endpoint)/\(path)") {
            var request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            if let token = accessToken {
                request.addValue("\(token)", forHTTPHeaderField: "X-Access-Token")
            }
            request.HTTPMethod = method
            if let data = httpBody {
                var err: NSError?
                if let json = toJson(dictionary: data) {
                    request.HTTPBody = json
                }
            }
            NSURLConnection.sendAsynchronousRequest(request, queue: queue) {
                response, data, connectionError -> Void in
                println("\(response)")
                if let error = connectionError {
                    println("Connection error for \(url) : \(error)")
                    if let jsonData = data {
                        var jsonResult = self.fromJson(jsonData)
                        println("Json error : \(jsonResult)")
                    }
                }
                else if let jsonData = data {
                    var jsonResult = self.fromJson(jsonData)
                    if let json = jsonResult {
                        println("Json decoded")
                        onSuccess(response!,json)
                    } else {
                        println("Error to decode json for \(url)")
                    }
                }
            }
        }
        
    }
    
    private static var currentToken: Token?
    static func getToken(onSuccess: (Token) -> Void)
    {
        if let token = currentToken {
            onSuccess(token)
        } else {
            sendRequest("tokens", method: "POST", data: [String:AnyObject](), onSuccess: {
                (response,result) -> Void in
                if let token = result["tokens"]?["id"] as? String {
                    self.currentToken = token
                    onSuccess(token)
                } else {
                    println("error to find id in result")
                }
            })
        }
    }
    
    static func getStories(onSuccess: ([Story]) -> Void)
    {
        getToken() {
            (token) in
            self.sendRequest("stories", accessToken: token, onSuccess: {
                (response,result) -> Void in
                if let jsonStories = result["stories"] as? [NSDictionary] {
                    var stories = [Story]()
                    for jsonStory in jsonStories {
                        if let story = Story(fromNSDictionary: jsonStory) {
                            stories.append(story)
                        }
                    }
                    onSuccess(stories)
                }
            })
        }
    }
    
    static func likeStory(story: Story){
        sendEvent("like", story: story)
    }
    
    static func nopeStory(story: Story){
        sendEvent("nope", story: story)
    }
    
    static func sendEvent(type: String, story: Story){
        getToken() {
            (token) in
            self.sendRequest("events", accessToken: token, method: "POST", data: ["events": ["type":"\(type)","storyId":"\(story.id)"]], onSuccess: {
                (response,result) -> Void in
                    println("Event \(type) for story \(story.id) sended")
            })
        }
    }
    
}

