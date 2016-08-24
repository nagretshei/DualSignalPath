//
//  ViewController.swift
//  DualSignalPath
//
//  Created by Lin Yi-Cheng on 2016/8/22.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var signalPath: UIView!
    var SignalPathLengh: CGFloat = 80
    var pathWithBlock = false
    
    @IBOutlet weak var backLine: UIView!
    @IBOutlet weak var backArrow: UILabel!
    
    
    @IBAction func addBlock(sender: UIButton) {
         let x = backLine.frame.origin.x + 10
         let y = backLine.center.y - 20
        addBlock(x, posY: y)
    }
    
    @IBAction func deleteBlock(sender: UIButton) {
        deleteBlock()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBlock(posX: CGFloat, posY: CGFloat){
        let block = UIButton()
        alertForInputName(block)
        block.frame = CGRectMake(posX, posY, 80, 40)
        block.backgroundColor = UIColor.grayColor()
        
        block.addTarget(self, action: #selector(ViewController.dragBlock(_:event:)), forControlEvents: UIControlEvents.TouchDragInside)
        
        self.view.addSubview(block)
        
    }
    
    
    
    func alertForInputName(button: UIButton){
        let alert = UIAlertController(title: "Input Name", message: "Please give a name showing on the block", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({(textField) -> Void in
            textField.text = "FX-1"
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: {(action) -> Void in
            let textField = alert.textFields![0] as UITextField
            button.setTitle(textField.text, forState: .Normal)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func dragBlock(button: UIButton, event: UIEvent){
        // make block moves
        for touch in event.touchesForView(button)!{
            let previousLocation: CGPoint = touch.previousLocationInView(button)
            let location: CGPoint = touch.locationInView(button)
            let deltaX: CGFloat = location.x - previousLocation.x
            let deltaY: CGFloat = location.y - previousLocation.y
            button.center = CGPointMake(button.center.x + deltaX, button.center.y + deltaY)
            
            moveOtherBlocks(button)
            
            // make signalPath strech
            if checkBlockOnPath() == true {
                print(checkBlockOnPath())
                signalPath.frame = CGRectMake(270, 64, getSingalPathLength(), 85)
                self.signalPath.setNeedsDisplay()
            }
            
            
     
            let backLineX = signalPath.frame.origin.x + signalPath.frame.width
            backLine.center = CGPoint(x: backLineX, y: signalPath.center.y)
            let backArrowX = backLine.frame.origin.x + backLine.frame.width
            backArrow.center = CGPoint(x: backArrowX, y: backLine.center.y)
            
        }
    }
    

    
    func getSingalPathLength() -> CGFloat {
        var totalLenghOfBlocksForFirstPath: CGFloat = 0
        var totalLenghOfBlocksForSecondPath: CGFloat = 0
        var blockCountsOnFirstPath: Int = 0
        var blockCountsOnSecondPath: Int = 0
        
        for block in self.view.subviews {
            // blocks on first Path
            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y <= signalPath.frame.origin.y + signalPath.frame.height / 2
            {
                totalLenghOfBlocksForFirstPath += block.frame.width
                blockCountsOnFirstPath += 1
            }
                
                // blocks on the second Path
            else if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2
            {
                totalLenghOfBlocksForSecondPath += block.frame.width
                blockCountsOnSecondPath += 1
            }
        }
        
        var result = CGFloat()
        if totalLenghOfBlocksForFirstPath >= totalLenghOfBlocksForSecondPath {
            result = totalLenghOfBlocksForFirstPath + CGFloat(30 * blockCountsOnFirstPath)
        } else {
            result = totalLenghOfBlocksForSecondPath + CGFloat(30 * blockCountsOnSecondPath)
        }
        
        SignalPathLengh = result
        return SignalPathLengh
    }
    
    
    func checkBlockOnPath() -> Bool {
        var result = false
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) == true
            {
                result =  true
            }
        }
        return result
    }
    
    func moveOtherBlocks(selfButton: UIButton){
        var previousBlock: UIButton = selfButton
        
//        for block in self.view.subviews {
//            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block != selfButton {
//                if previousBlock.frame.intersects(block.frame) == true {
//                    previousBlock = block as! UIButton
//                    
//                    if block.center.x >= selfButton.center.x
//                    {
//                        block.center.x = selfButton.center.x + 100
//                        
//                    }
//                    else if block.center.x < selfButton.center.x
//                    {
//                        block.center.x = selfButton.center.x - 100
//                    }
//                }
//            }
//            
//        }
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && block.frame.width >= 80 && previousBlock.frame.intersects(block.frame) && block != previousBlock {
                if previousBlock.frame.intersects(block.frame) == true {
                    if block.center.x >= previousBlock.center.x
                    {
                        //block.center.x = previousBlock.center.x + 100
                        block.center.x += 15
                        previousBlock = block as! UIButton
                        
                    }
                    else if block.center.x < previousBlock.center.x
                    {
                        //block.center.x = previousBlock.center.x - 100
                        block.center.x -= 15
                        previousBlock = block as! UIButton
                        
                    } else
                    {
                        previousBlock = block as! UIButton
                    }
                }
            }
            
        }
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && block.frame.width >= 80 && previousBlock.frame.intersects(block.frame) && block != previousBlock {
                if previousBlock.frame.intersects(block.frame) == true {
                    if block.center.x >= previousBlock.center.x
                    {
                        //block.center.x = previousBlock.center.x + 100
                        block.center.x += 15
                        previousBlock = block as! UIButton
                        
                    }
                    else if block.center.x < previousBlock.center.x
                    {
                        //block.center.x = previousBlock.center.x - 100
                        block.center.x -= 15
                        previousBlock = block as! UIButton
                        
                    } else
                    {
                        previousBlock = block as! UIButton
                    }
                }
            }
            
        }
        
//        for block in self.view.subviews {
//            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block != previousBlock {
//                if previousBlock.frame.intersects(block.frame) == true {
//                    //previousBlock = block as! UIButton
//                    
//                    if block.center.x >= previousBlock.center.x
//                    {
//                        block.center.x = selfButton.center.x + 100
//                        previousBlock = block as! UIButton
//                    }
//                    else if block.center.x < selfButton.center.x
//                    {
//                        block.center.x = selfButton.center.x - 100
//                        previousBlock = block as! UIButton
//                    }
//                }
//            }
//            
//        }
//        //var previousBlock: UIButton = selfButton
//        for everyBlock in self.view.subviews {
//            if everyBlock.isKindOfClass(UIButton) && signalPath.frame.intersects(everyBlock.frame) {
//                
//                for block in self.view.subviews {
//                    if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block != everyBlock {
//                        if everyBlock.frame.intersects(block.frame) == true {
//                            
//                            if block.center.x >= everyBlock.center.x
//                            {
//                                block.center.x = everyBlock.center.x + 100
//                                
//                            }
//                            else if block.center.x < everyBlock.center.x
//                            {
//                                block.center.x = everyBlock.center.x - 100
//                            }
//                        }
//                    }
//                    
//                }
//            }
//        }
     
    }
    
    
    
    func deleteBlock(){
        if self.view.subviews.last!.isKindOfClass(UIButton) {
            self.view.subviews.last!.removeFromSuperview()

        }
    }
}

