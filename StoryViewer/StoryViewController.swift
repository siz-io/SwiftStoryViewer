//
//  StoryViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 09/04/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private struct Grid: Printable {
        let nbLines: Int
        let nbColumns: Int
        
        let storyboardId: String
        
        init(_ nbLines: Int, _ nbColumns: Int) {
            self.nbLines = nbLines
            self.nbColumns = nbColumns
            storyboardId = "Story View \(nbLines)x\(nbColumns)"
        }
        
        var description: String {
            return "(\(nbLines),\(nbColumns))"
        }
        
        private func area(story:Story, viewController: StoryViewController) -> Int
        {
            let videoBox = story.boxes[0]
            let boxRatio = videoBox.ratio()
            let storyViewSize = (height: Double(viewController.view.bounds.height),width:Double(viewController.view.bounds.width))
            let screenScale = Double(UIScreen.mainScreen().scale)
            let pixelCellSize =
            (width: Int(storyViewSize.width/Double(nbColumns)*screenScale),
                height: Int(storyViewSize.height/Double(nbLines)*screenScale))
            let screenRatio = Double(pixelCellSize.width)/Double(pixelCellSize.height)
            let nbCell = nbLines * nbColumns
            
            if(boxRatio > screenRatio)
            {
                let newWidth = pixelCellSize.width,
                widthRatio = Double(newWidth)/Double(videoBox.width),
                newHeight = Int(Double(videoBox.height)*widthRatio)
                let area = newWidth*newHeight*nbCell
                println("grid=\(self) storyViewSize=\(storyViewSize.width)x\(storyViewSize.height) screenScale=\(screenScale) cellSize=\(pixelCellSize.width)x\(pixelCellSize.height) boxSize=\(videoBox.width)x\(videoBox.height) newBoxSize=\(newWidth)x\(newHeight) area=\(area)")
                return area
            } else {
                let newHeight = pixelCellSize.height,
                heightRatio = Double(newHeight)/Double(videoBox.height),
                newWidth = Int(Double(videoBox.width)*heightRatio)
                let area = newWidth*newHeight*nbCell
                println("grid=\(self) storyViewSize=\(storyViewSize.width)x\(storyViewSize.height) screenScale=\(screenScale) cellSize=\(pixelCellSize.width)x\(pixelCellSize.height) boxSize=\(videoBox.width)x\(videoBox.height) newBoxSize=\(newWidth)x\(newHeight) area=\(area)")
                return area
            }
        }
        
        static let grids = [
            Grid(2,2),
            Grid(4,1),
            Grid(1,4)]
        
        static func bestGridForStory(story:Story, viewController: StoryViewController) -> Grid {
            return grids.reduce(grids.first!) {
                let area0 = $0.area(story,viewController: viewController)
                let area1 = $1.area(story,viewController: viewController)
                return (area0>area1 ? $0 : $1)
            }
        }
    }
    

    
    private weak var gridViewController: StoryGridViewController?
    
    var story: Story? {
        didSet {
            updateUI()
        }
    }
    
    func play()
    {
        gridViewController?.play()
    }

    private func updateUI() {
        if let model = story {
            titleLabel.text = model.title
            let bestGrid = Grid.bestGridForStory(model, viewController: self)
            changeGrid(bestGrid.storyboardId)
        } else {
            titleLabel.text = .None
        }
    }
    
    @IBAction func changeGridAction(sender: UIButton) {
        changeGrid(sender.currentTitle!)
    }
    
    func changeGrid(newGrid: String){
        if var newController = storyboard?.instantiateViewControllerWithIdentifier(newGrid) as? StoryGridViewController {
            newController.story = story
            newController.view.frame = self.view.frame
            newController.view.constraints()
            newController.willMoveToParentViewController(self)
            self.addChildViewController(newController)
            self.transitionFromViewController(gridViewController!,
                toViewController: newController,
                duration: 0.0, options: nil,
                animations: nil) {
                (finished) in
                    newController.didMoveToParentViewController(self)
                    self.gridViewController?.removeFromParentViewController()
                    self.gridViewController = newController
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let gridViewController = segue.destinationViewController as? StoryGridViewController {
            self.gridViewController = gridViewController
            updateUI()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateUI()
    }
}
