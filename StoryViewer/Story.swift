//
//  Story.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 30/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import Foundation

class Story
{
    let id: String
    
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
    
    private struct Database {
        static let storyIds = ["1426589791593b2493fba815","1427469323995ed5cd418e9f","14274674523774c0ce58fca8","142746486623048953be9ce8","1427463698833a8039eef668","14274635585026374000e5fa","14274587736024eea248c438","1427457701047780790e00b1","1427456107646465bc0c8c5d","14274553480930af2fe62e48","142745454635644e9cb4236b"]
    }
    
    class func getRandomStory() -> Story {
        let randomIndex = Int(arc4random_uniform(UInt32(Database.storyIds.count)))
        return Story(id: Database.storyIds[randomIndex])
    }
}