//
//  StoryContainerViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 26/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    var videoViewControllers = [Int:VideoViewController]()
    
    var model: Story? {
        didSet {
            if let story = model {
                for (i,controller) in videoViewControllers {
                    let currentBox = i%story.boxes.count
                    controller.sourceURL = story.boxes[currentBox]
                }
            }
        }
    }
        
    func loadStory(story: Story)
    {
        model=story
    }
    
    func play()
    {
        for (_,controller) in videoViewControllers {
            controller.play()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if let videoViewController = segue.destinationViewController as? VideoViewController {
                switch identifier {
                case "firstVideo" : videoViewControllers[0] = videoViewController
                case "secondVideo" : videoViewControllers[1] = videoViewController
                case "thirdVideo" : videoViewControllers[2] = videoViewController
                case "fourthVideo": videoViewControllers[3] = videoViewController
                default: break
                }
            }
        }
    }
}
