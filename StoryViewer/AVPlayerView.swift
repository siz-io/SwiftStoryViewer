//
//  AVPlayerView.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 18/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView : UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    var videoPlayer: AVPlayer? {
        set {
            let layer: AVPlayerLayer = self.layer as AVPlayerLayer
            layer.player = newValue
        }
        get {
            let layer: AVPlayerLayer = self.layer as AVPlayerLayer
            return layer.player
        }
    }
    var videoPlayerItem: AVPlayerItem?
    
    func loadVideo(sourceURL: String) {
        let url = NSURL(string: sourceURL)
        videoPlayerItem = AVPlayerItem(URL: url)
        if let playerItem = videoPlayerItem {
            videoPlayer = AVPlayer(playerItem: playerItem)
            if let player = videoPlayer {
                player.actionAtItemEnd = .None
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer?.currentItem)
                player.play()
            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification)
    {
        restartVideo()
    }
    
    func restartVideo()
    {
        if let player = videoPlayer {
            player.seekToTime(CMTimeMake(0, 1))
            player.play()
        }
    }
}