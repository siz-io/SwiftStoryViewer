//
//  ViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 17/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    var moviePlayer : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() {
       let url = NSURL(string: "http://fun.siz.io/stories/1425445499218efb0f23ec97/2.mp4")
       moviePlayer = MPMoviePlayerController(contentURL: url)
       if let player = moviePlayer {
            player.view.frame = CGRect(x: 0, y: 0, width: 352, height: 226)
            self.view.addSubview(player.view)
            player.controlStyle = MPMovieControlStyle.None
            player.repeatMode = MPMovieRepeatMode.One
            player.play()
        }
    }
}

