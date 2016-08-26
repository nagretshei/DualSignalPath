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
    let blockSpace: CGFloat = 30
    let blockWidth: CGFloat = 50
    
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

    // View
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
        let lengthOffset: CGFloat = 100
        
        if checkBlockOnPath(backLine) == true {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: lengthOffset) - lengthOffset, 3)
                }, completion: nil)
            calculateTheEndOfBackLineX()
            
        } else {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: lengthOffset), 3)
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

    
    // Controller
    func addBlock(posX: CGFloat, posY: CGFloat){
        let block = UIButton()
        alertForInputName(block)
        block.frame = CGRectMake(posX, posY, blockWidth, 40)
        block.backgroundColor = UIColor.grayColor()
        block.titleLabel!.adjustsFontSizeToFitWidth = true
        
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
    
    func deleteBlock(){
        selectedBlock.removeFromSuperview()
        makeFrontLineFlexible()
        makeSignalPathsFlexible()
        makeBackLineFlexible()
        moveBackArrow()
        //setBlocksRelativePositionToPath(button)
        
    }
    
    func touchBlock(button: UIButton){
        selectedBlock = button
        selectedBlock.backgroundColor = UIColor.redColor()
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != selectedBlock {
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

            makeFrontLineFlexible()
            makeSignalPathsFlexible()
            makeBackLineFlexible()
            moveBackArrow()
            setBlocksRelativePositionToPath(button)
        }
    }
    
    // Model
    func setBlocksRelativePositionToPath(button: UIButton){
        let buttonRightSideX: CGFloat = button.frame.origin.x + blockWidth
        //let buttonLeftMidlePoint: CGPoint = CGPoint(x: button.frame.origin.x, y: button.center.y)
        let accuracy : CGFloat = 5
        let rightReferencePoint = CGPoint(x: buttonRightSideX - accuracy, y: button.center.y)
        let leftReferencePoint = CGPoint(x: button.frame.origin.x + accuracy, y: button.center.y)
        lengthChange()
        if changedLength == 0 {
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && button.frame.contains(block.center){
                    
                    if block.center.x < button.center.x && block.frame.contains(rightReferencePoint) && blockDragedLength < 0
                        
                    {
                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                            block.center = CGPoint(x: block.center.x + self.blockSpace + block.frame.width, y: block.center.y)
                            }, completion: nil)
                    }
                    
                    else if block.center.x > button.center.x && block.frame.contains(leftReferencePoint) && blockDragedLength > 0
                    {
                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                            block.center = CGPoint(x: block.center.x - self.blockSpace - block.frame.width, y: block.center.y)
                            }, completion: nil)
                    }
                }
            }
        } else
        {
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x
                {  UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                    block.center.x += self.changedLength
                    }, completion: nil)
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
        let result: CGFloat = totalLenghOfLine + blockSpace * CGFloat(blockCountsOnLine)
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
            result = totalLenghOfBlocksForFirstPath + blockSpace * CGFloat(blockCountsOnFirstPath)
        } else {
            result = totalLenghOfBlocksForSecondPath + blockSpace * CGFloat(blockCountsOnSecondPath)
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
}

