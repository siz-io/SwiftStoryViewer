//
//  Story.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 30/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import Foundation

class Story: Printable
{
    let id: String
    
    var description: String {
        get {
            return "id=\(id)"
        }
    }
    
    var boxes: [String] {
        get {
            return ["http://fun.siz.io/stories/\(id)/0.mp4",
                "http://fun.siz.io/stories/\(id)/1.mp4",
                "http://fun.siz.io/stories/\(id)/2.mp4",
                "http://fun.siz.io/stories/\(id)/3.mp4"]
        }
    }
    
    init(id: String) {
        self.id = id
    }
    
    init?(fromNSDictionary dict: NSDictionary)
    {
        if let id = dict["id"] as? String {
            self.id = id
        } else {
            self.id = ""
            return nil
        }
    }
        
    struct Database {
        static var currentStories = [Story]()
    }
    
    class func getNextStory(onSuccess: (Story) -> Void) {
        if !Database.currentStories.isEmpty {
            onSuccess(Story(id: Database.currentStories.removeAtIndex(0).id))
        } else {
            getStories() {
                (stories) in
                    self.getNextStory(onSuccess)
            }
        }
    }
    
    class func getStories(onSuccess: ([Story]) -> Void) {
        if !Database.currentStories.isEmpty {
            onSuccess(Database.currentStories)
        } else {
            NetworkController.getStories {
                (stories) -> Void in
                Database.currentStories = stories
                onSuccess(stories)
            }
        }
        
    }
}