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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var story: Story? {
        didSet {
            if let model = story {
                for (i,controller) in videoViewControllers {
                    let currentBox = i%model.boxes.count
                    controller.sourceURL = model.boxes[currentBox]
                }
            }
        }
    }
    
    func play()
    {
        for (_,controller) in videoViewControllers {
            controller.play()
        }
    }
    
    func changeTo1x4()
    {
        if var newController = storyboard?.instantiateViewControllerWithIdentifier("Story View 4x1") as? StoryViewController {
            newController.view.frame = parentViewController!.view.bounds
            newController.story = self.story?
            parentViewController?.addChildViewController(newController)
            willMoveToParentViewController(nil)
            parentViewController?.transitionFromViewController(self,
                toViewController: newController,
                duration: 0,
                options: UIViewAnimationOptions.TransitionNone,
                animations: {},
                completion: { (finished: Bool) -> Void in
                    self.removeFromParentViewController()
                    newController.didMoveToParentViewController(self)
                }
            )
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
