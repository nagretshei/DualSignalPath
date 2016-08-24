//
//  ViewController.swift
//  DualSignalPath
//
//  Created by Lin Yi-Cheng on 2016/8/22.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var frontLine: UIView!
    @IBOutlet weak var signalPath: UIView!
    @IBOutlet weak var hollow: UIView!
    @IBOutlet weak var backLine: UIView!
    @IBOutlet weak var backArrow: UILabel!
    
    
    var pathWithBlock = false
    var blockCount: Int = 0
    var signalPathX = CGFloat()
    var backLineX = CGFloat()
    var theEndOfBackLineX = CGFloat()
    var signalPathLengh: CGFloat = 40
    
    //var needToResetPath = Bool()
    
    
    @IBAction func addBlock(sender: UIButton) {
         let x = backLine.frame.origin.x + 10
         let y = backLine.center.y - 20
        addBlock(x, posY: y)
        blockCount += 1
    }
    
    @IBAction func deleteBlock(sender: UIButton) {
        deleteBlock()
        if blockCount > 0 {
            blockCount -= 1
        }
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
            
            alignBlocks(button)
            makeFrontLineFlexible()
            makeSignalPathsFlexible()
            makeBackLineFlexible()
            moveBackArrow()

        }
    }
    
    func makeFrontLineFlexible(){
        frontLine.frame = CGRectMake(frontLine.frame.origin.x, frontLine.frame.origin.y, getLinesLength(frontLine, lengthOffset: 21), 3)
    }
    
    func makeSignalPathsFlexible(){
        signalPathX = frontLine.frame.origin.x + frontLine.frame.width
        signalPath.frame = CGRectMake(signalPathX, signalPath.frame.origin.y, getSingalPathLength(), 63)
        hollow.frame = CGRectMake(hollow.frame.origin.x , hollow.frame.origin.y, signalPathLengh - CGFloat(6), 57)
    }
    
    func makeBackLineFlexible(){
        backLineX = signalPathX + signalPath.frame.width
        
        if checkBlockOnPath(backLine) == true {
        backLine.frame = CGRectMake(backLineX, backLine.frame.origin.y, getLinesLength(backLine, lengthOffset: 100) - 100, 3)
        } else {
    backLine.frame = CGRectMake(backLineX, backLine.frame.origin.y, getLinesLength(backLine, lengthOffset: 100), 3)
        }
    }
    
    func moveBackArrow(){
        let backArrowX = backLine.frame.origin.x + backLine.frame.width
        backArrow.center = CGPoint(x: backArrowX, y: backLine.center.y)
    }
    
    func getLinesLength(line: UIView, lengthOffset: CGFloat) -> CGFloat {
        var totalLenghOfLine: CGFloat = lengthOffset
        var blockCountsOnLine: Int = 0
        
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && line.frame.intersects(block.frame)
            {
                totalLenghOfLine += block.frame.width
                blockCountsOnLine += 1
            }
        }
        let result: CGFloat = totalLenghOfLine + CGFloat(30 * blockCountsOnLine)
        return result
    }
    
    func getSingalPathLength() -> CGFloat {
        var totalLenghOfBlocksForFirstPath: CGFloat = 40
        var totalLenghOfBlocksForSecondPath: CGFloat = 40
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
        
        signalPathLengh = result
        return signalPathLengh
    }
    
    
    func checkBlockOnPath(part: UIView) -> Bool {
        var result = false
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && part.frame.intersects(block.frame) == true
            {
                result =  true
            }
        }
        return result
    }
    
    func alignBlocks(selfButton: UIButton){
        var previousBlock: UIButton = selfButton
        
        for i in 1...blockCount {
            
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && block.frame.width >= 80 && previousBlock.frame.intersects(block.frame) && block != previousBlock {
                    if previousBlock.frame.intersects(block.frame) == true {
                        if block.center.x >= previousBlock.center.x
                        {
                            //block.center.x = previousBlock.center.x + 100
                            block.center.x += 20
                            previousBlock = block as! UIButton
                            
                        }
                        else if block.center.x < previousBlock.center.x
                        {
                            //block.center.x = previousBlock.center.x - 100
                            block.center.x -= 20
                            previousBlock = block as! UIButton
                            
                        } else
                        {
                            previousBlock = block as! UIButton
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    func deleteBlock(){
        if self.view.subviews.last!.isKindOfClass(UIButton) {
            self.view.subviews.last!.removeFromSuperview()

        }
    }
}

