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
    struct Format
    {
        let type: String
        let href: String
        
        init?(fromNSDictionary dict: NSDictionary)
        {
            if let type = dict["type"] as? String {
                self.type = type
                if let href = dict["href"] as? String {
                    self.href = href
                    return
                }
            }
            return nil
        }
    }
    
    struct Box
    {
        let height: Int
        let width: Int
        let formats: [Format]
        
        init?(fromNSDictionary dict: NSDictionary)
        {
            if let height = dict["height"] as? Int {
                self.height = height
                if let width = dict["width"] as? Int {
                    self.width = width
                    if let formatDicts = dict["formats"] as? [NSDictionary] {
                        var formats = [Format]()
                        for formatDict in formatDicts {
                            if let format = Format(fromNSDictionary: formatDict) {
                                formats.append(format)
                            }
                        }
                        self.formats = formats
                        return
                    }
                }
            }
            return nil
        }
        
        
        func ratio() -> Double {
            return Double(width)/Double(height)
        }
        
    }
    
    let id: String
    let boxes: [Box]
    let title: String
    
    init?(fromNSDictionary dict: NSDictionary)
    {
        if let id = dict["id"] as? String,
            title = dict["title"] as? String,
            boxesDict = dict["boxes"] as? [NSDictionary]
        {
            self.id = id
            self.title = title
            
            var boxes = [Box]()
            for boxDict in boxesDict {
                if let box = Box(fromNSDictionary: boxDict) {
                    boxes.append(box)
                }
            }
            self.boxes = boxes
        } else {
            self.id = ""
            self.title = ""
            self.boxes = [Box]()
            return nil
        }
    }
    
    var description: String {
        get {
            return "id=\(id)"
        }
    }

    
    struct Database {
        static var currentStories = [Story]()
    }
    
    class func getNextStory(onSuccess: (Story) -> Void) {
        if !Database.currentStories.isEmpty {
            let nextStory = Database.currentStories.removeAtIndex(0)
            onSuccess(nextStory)
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
