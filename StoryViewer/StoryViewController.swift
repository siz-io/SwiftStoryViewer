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
        
    func loadStory(id: String)
    {
            topLeftVideo.loadVideo("http://fun.siz.io/stories/\(id)/0.mp4")
            topRightVideo.loadVideo("http://fun.siz.io/stories/\(id)/1.mp4")
            bottomLeftVideo.loadVideo("http://fun.siz.io/stories/\(id)/2.mp4")
            bottomRightVideo.loadVideo("http://fun.siz.io/stories/\(id)/3.mp4")
       
    }
}
