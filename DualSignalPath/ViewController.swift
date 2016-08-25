//
//  ViewController.swift
//  DualSignalPath
//
//  Created by Lin Yi-Cheng on 2016/8/22.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var frontLine = UIView()
    var signalPath = UIView()
    var hollow = UIView()
    var backLine = UIView()
    var backArrow = UILabel()
    
    
    var blockCount: Int = 0
    var signalPathX: CGFloat = 162
    var backLineX: CGFloat = 202
    var theEndOfBackLineX: CGFloat = 302
    var signalPathLength: CGFloat = 40
    var selectedBlock = UIButton()
    
    var touchPosition = CGPoint()
    var blockDragedLength = CGFloat()
    
    var previousTheEndOfBackLineX = CGFloat()
    var changedLength = CGFloat()
    
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
        setViews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            touchPosition = touch.locationInView(view)
            deSelect(touchPosition)
            
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
//            
//            }, completion: nil)
//    }

    func setViews(){
        frontLine.frame = CGRectMake(141, 100, 21, 3)
        frontLine.backgroundColor = UIColor.grayColor()
        view.addSubview(frontLine)

        signalPath.frame = CGRectMake(162, 70, 40, 63)
        signalPath.backgroundColor = UIColor.grayColor()
        view.addSubview(signalPath)
        
        hollow.frame = CGRectMake(3, 3, 34, 57)
        hollow.backgroundColor = UIColor.whiteColor()
        signalPath.addSubview(hollow)
        
        backLine.frame = CGRectMake(202, 100, 100, 3)
        backLine.backgroundColor = UIColor.grayColor()
        view.addSubview(backLine)
        
        backArrow.frame = CGRectMake(300, 93, 29, 18)
        backArrow.text = "➤"
        backArrow.textColor = UIColor.lightGrayColor()
        view.addSubview(backArrow)
        
    }
    func addBlock(posX: CGFloat, posY: CGFloat){
        let block = UIButton()
        alertForInputName(block)
        block.frame = CGRectMake(posX, posY, 80, 40)
        block.backgroundColor = UIColor.grayColor()
        
        block.addTarget(self, action: #selector(ViewController.dragBlock(_:event:)), forControlEvents: UIControlEvents.TouchDragInside)
        block.addTarget(self, action: #selector(ViewController.touchBlock(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func touchBlock(button: UIButton){
        selectedBlock = button
        selectedBlock.backgroundColor = UIColor.redColor()
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && block.frame.width >= 80 && block != selectedBlock {
                block.backgroundColor = UIColor.lightGrayColor()
            }
        }
    }
    
    func deSelect(touch: CGPoint){
        for view in self.view.subviews {
            if view.frame.contains(touch) == false {
                selectedBlock.backgroundColor = UIColor.lightGrayColor()
                
            }
        }
    }
    
    func dragBlock(button: UIButton, event: UIEvent){
        selectedBlock = button
        
        // make block moves
        for touch in event.touchesForView(button)!{
            let previousLocation: CGPoint = touch.previousLocationInView(button)
            let location: CGPoint = touch.locationInView(button)
            let deltaX: CGFloat = location.x - previousLocation.x
            let deltaY: CGFloat = location.y - previousLocation.y
            button.center = CGPointMake(button.center.x + deltaX, button.center.y + deltaY)
            blockDragedLength = deltaX
            
            //alignBlocks(button)
            makeFrontLineFlexible()
            makeSignalPathsFlexible()
            makeBackLineFlexible()
            moveBackArrow()
            setBlocksRelativePositionToPath(button)
        }
    }
    
    func setBlocksRelativePositionToPath(button: UIButton){
        lengthChange()
        if changedLength == 0 {
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && block.frame.width >= 80 && block != button && block.center.x < button.center.x && block.frame.contains(button.frame.origin)
                {
                    block.center.x = button.center.x + block.frame.width
                }
            }
        } else
        {
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && block.frame.width >= 80 && block != button && block.center.x >= button.center.x {
                    block.center.x += changedLength
                }
            }
        }
        
    }
    
    func calculateTheEndOfBackLineX(){
        theEndOfBackLineX = backLineX + backLine.frame.width

    }
    
    func lengthChange(){
        changedLength = theEndOfBackLineX - previousTheEndOfBackLineX

    }
    
    
    func makeFrontLineFlexible(){
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            self.frontLine.frame = CGRectMake(self.frontLine.frame.origin.x, self.frontLine.frame.origin.y, self.getLinesLength(self.frontLine, lengthOffset: 21), 3)
            
            }, completion: nil)
    }
    
    func makeSignalPathsFlexible(){
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            self.signalPathX = self.frontLine.frame.origin.x + self.frontLine.frame.width
            self.signalPath.frame = CGRectMake(self.signalPathX, self.signalPath.frame.origin.y, self.getSingalPathLength(), 63)
            self.hollow.frame = CGRectMake(self.hollow.frame.origin.x , self.hollow.frame.origin.y, self.signalPathLength - CGFloat(6), 57)
            }, completion: nil)
    }
    
    func makeBackLineFlexible(){
        
        previousTheEndOfBackLineX = theEndOfBackLineX
        backLineX = signalPathX + signalPath.frame.width
            
        if checkBlockOnPath(backLine) == true {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: 100) - 100, 3)
                }, completion: nil)
            calculateTheEndOfBackLineX()

        } else {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: 100), 3)
                }, completion: nil)
            calculateTheEndOfBackLineX()
        }
    }
    
    func moveBackArrow(){
        let backArrowX = backLine.frame.origin.x + backLine.frame.width
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            self.backArrow.center = CGPoint(x: backArrowX + 10, y: self.backLine.center.y)
            }, completion: nil)
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
        
        signalPathLength = result
        return signalPathLength
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
        
        //  block  | previous
        // previous   |    block
        
        if blockCount > 1 && changedLength == 0 {
            for i in 1...blockCount {
                for block in self.view.subviews {
                    if block.isKindOfClass(UIButton) && block.frame.width >= 80 && block != previousBlock && previousBlock.frame.intersects(block.frame) == true {
                        
                        let midPoint = (block.center.x + previousBlock.center.x) / 2
                        
                        if block.center.x >= previousBlock.center.x
                        {
  
                            //block.center.x -= blockDragedLength
//                            if block.center.x == previousBlock.center.x {
//                                print("+++++++++")
//                                block.center.x += block.frame.width / 2
//                                previousBlock.center.x -= block.frame.width / 2
//                            }
                            block.center.x = previousBlock.center.x - block.frame.width
                            previousBlock = block as! UIButton
                            
                        }
                        else if block.center.x < previousBlock.center.x
                        {
                            block.center.x = previousBlock.center.x + block.frame.width
                            //previousBlock.center.x = block.center.x
                            //previousBlock.center.x = touchPosition.x
                            
                           // block.center.x += blockDragedLength
//                            print("========")
//                             if block.center.x == previousBlock.center.x {
//                                block.center.x -= block.frame.width / 2
//                                previousBlock.center.x += block.frame.width / 2
//
//                            }
                            
                            
                            //block.center.x = touchPosition.x + blockDragedLength
                            
                            
                            previousBlock = block as! UIButton
                            
                        }
                            
                        else
                        {
                            previousBlock = block as! UIButton
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteBlock(){
        selectedBlock.removeFromSuperview()
        makeFrontLineFlexible()
        makeSignalPathsFlexible()
        makeBackLineFlexible()
        moveBackArrow()
        //setBlocksRelativePositionToPath(button)

    }
}

