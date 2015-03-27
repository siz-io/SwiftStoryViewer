//
//  ViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 17/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var storyViewContainer: UIView!
    
    var storyViewController: StoryViewController!
    
    let storyIds = ["1426589791593b2493fba815","1427469323995ed5cd418e9f","14274674523774c0ce58fca8","142746486623048953be9ce8","1427463698833a8039eef668","14274635585026374000e5fa","14274587736024eea248c438","1427457701047780790e00b1","1427456107646465bc0c8c5d","14274553480930af2fe62e48","142745454635644e9cb4236b"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewStory()
    }
    
    func loadNewStory() {
        let randomIndex = Int(arc4random_uniform(UInt32(storyIds.count)))
        storyViewController.loadStory(storyIds[randomIndex])
    }
    
    private struct Constants {
        static let translationScale: CGFloat = 1.5
        static let timeToReturnToIdentity = 0.3
        static let timeToExitStory = 0.3
        static let minPercentOfPan: Float = 0.30
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let storyViewController = segue.destinationViewController as? StoryViewController {
            self.storyViewController = storyViewController
        }
    }
    
    @IBAction func dragStory(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            let screenWidth = self.view.bounds.width
            let minTranslationX = Float(screenWidth)*Constants.minPercentOfPan
            let translationX = Float(abs(gesture.translationInView(storyViewContainer).x*Constants.translationScale))
            if(translationX > minTranslationX)
            {
                UIView.animateWithDuration(
                    Constants.timeToExitStory,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        self.storyViewContainer.transform = CGAffineTransformMakeTranslation(screenWidth, 0)
                    },
                    completion: { (result:Bool) in
                        self.loadNewStory()
                        self.returnToIdentity()
                    }
                )
                
            } else {
                returnToIdentity()
            }
            
            println("TranslationX=\(translationX) MinTranslationX=\(minTranslationX)")
        case .Changed:
            let translation = gesture.translationInView(storyViewContainer)
            let xOffset = translation.x * Constants.translationScale
            if xOffset != 0 {
                self.storyViewContainer.transform = CGAffineTransformMakeTranslation(xOffset,0)
            }
        default: break
        }
    }
    
    func returnToIdentity(){
        UIView.animateWithDuration(
            Constants.timeToReturnToIdentity,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.storyViewContainer.transform = CGAffineTransformIdentity
            },
            completion: .None
        )
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


