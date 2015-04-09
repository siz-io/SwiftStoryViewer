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
            let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
            layer.player = newValue
            layer.videoGravity = AVLayerVideoGravityResizeAspect
        }
        get {
            let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
            return layer.player
        }
    }
}
