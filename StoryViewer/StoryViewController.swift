//
//  StoryContainerViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 26/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var topLeftVideo: AVPlayerView!
    @IBOutlet weak var topRightVideo: AVPlayerView!
    @IBOutlet weak var bottomLeftVideo: AVPlayerView!
    @IBOutlet weak var bottomRightVideo: AVPlayerView!
    
    var model: Story? {
        didSet {
            if let story = model {
                topLeftVideo.loadVideo(story.boxes[0])
                topRightVideo.loadVideo(story.boxes[1])
                bottomLeftVideo.loadVideo(story.boxes[2])
                bottomRightVideo.loadVideo(story.boxes[3])
            }
        }
    }
        
    func loadStory(story: Story)
    {
        model=story
    }
    
    func play()
    {
        topLeftVideo.play()
        topRightVideo.play()
        bottomLeftVideo.play()
        bottomRightVideo.play()
    }
}
