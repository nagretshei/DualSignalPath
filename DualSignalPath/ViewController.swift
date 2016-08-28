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
    var resetZone = UIView()
    var backLine = UIView()
    var backArrow = UILabel()
    var demoBlock = UIButton()
    
    var blockCount: Int = 0
    var signalPathX: CGFloat = 162
    var backLineX: CGFloat = 202
    
    var theEndOfFrontLineX: CGFloat = 162
    var theEndOfSignalPathX: CGFloat = 202
    var theEndOfBackLineX: CGFloat = 302
    
    var signalPathLength: CGFloat = 40
    var frontLineLength: CGFloat = 21
    var backLineLength: CGFloat = 21
    var selectedBlock = UIButton()
    let blockSpace: CGFloat = 30
    let blockWidth: CGFloat = 50
    
    var touchPosition = CGPoint()
    var blockDragedLength = CGFloat()
    
    var previousTheEndOfFrontLineX = CGFloat()
    var previousTheEndOfSignalPathX = CGFloat()
    var previousTheEndOfBackLineX = CGFloat()
    
    var totalChangedLength = CGFloat()
    
    var blockOnFirstPath = [UIView]()
    var blockOnSecondPath = [UIView]()
    var blockOnFrontLine = [UIView]()
    var blockOnBackLine = [UIView]()
    
    var previousFrontLineLength = CGFloat()
    var previousBackLineLength = CGFloat()
    
    var frontLineChangedLength = CGFloat()
    var signalPathChangedLength = CGFloat()
    var backLineChangedLength = CGFloat()
    var changedView = [UIView]()
    
    @IBAction func addBlock(sender: UIButton) {
        demoBlock.removeFromSuperview()
        
        let x = backLine.frame.origin.x + 10
        let y = backLine.center.y - 20
        addBlock(x, posY: y)
        blockCount += 1
        alignEverything()
        
        print(blockOnFrontLine.count)
    }
    
    @IBAction func deleteBlock(sender: UIButton) {
        deleteBlock()
        if blockCount > 0 {
            blockCount -= 1
        }
        alignEverything()

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
            alignEverything()

        }
    }
    
    // View
    
    func setViews(){
        frontLine.frame = CGRectMake(141, 101, 21, 3)
        frontLine.backgroundColor = UIColor.grayColor()
        view.addSubview(frontLine)
        
        signalPath.frame = CGRectMake(162, 70, 40, 63)
        signalPath.backgroundColor = UIColor.grayColor()
        view.addSubview(signalPath)
        
        hollow.frame = CGRectMake(3, 3, 34, 57)
        hollow.backgroundColor = UIColor.whiteColor()
        signalPath.addSubview(hollow)
        
        resetZone.frame = CGRectMake(5, 25, 30, 10)
        resetZone.backgroundColor = UIColor.greenColor()
        signalPath.addSubview(resetZone)
        
        
        backLine.frame = CGRectMake(202, 100, 21, 3)
        backLine.backgroundColor = UIColor.grayColor()
        view.addSubview(backLine)
        
        backArrow.frame = CGRectMake(300, 93, 29, 18)
        backArrow.text = "➤"
        backArrow.textColor = UIColor.lightGrayColor()
        view.addSubview(backArrow)
        
        let x = backLine.frame.origin.x + 10
        let y = backLine.center.y - 20
        demoBlock.frame = CGRectMake(x, y, blockWidth, 40)
        demoBlock.backgroundColor = UIColor.clearColor()
        view.addSubview(demoBlock)
        alignEverything()
        
    }
    
    func resetAllLinesLengthAndCulculatesBlocks(){
        makeFrontLineFlexible()
        makeSignalPathsFlexible()
        makeBackLineFlexible()
        moveBackArrow()

    }
    
    func alignEverything(){
        resetAllLinesLengthAndCulculatesBlocks()
        alignArrayOfBlocks(blockOnFirstPath)
        alignArrayOfBlocks(blockOnSecondPath)
        alignArrayOfBlocks(blockOnFrontLine)
        alignArrayOfBlocks(blockOnBackLine)
        putOutSideBlocksBackToSignalPath()
    }
    
    func makeFrontLineFlexible(){
        previousTheEndOfFrontLineX = theEndOfFrontLineX
        
        let length = getFrontLinesLength()
        
        let frontLineX = frontLine.frame.origin.x
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            
            self.frontLine.frame = CGRectMake(frontLineX, self.frontLine.frame.origin.y, length, 3)
            
            }, completion: nil)
        
        theEndOfFrontLineX = frontLineX + length
    }
    
    func makeSignalPathsFlexible(){
        previousTheEndOfSignalPathX = theEndOfSignalPathX
        
        signalPathX = frontLine.frame.origin.x + frontLine.frame.width
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            
            self.signalPath.frame = CGRectMake(self.signalPathX, self.signalPath.frame.origin.y, self.getSingalPathLength(), 63)
            self.hollow.frame = CGRectMake(self.hollow.frame.origin.x , self.hollow.frame.origin.y, self.signalPathLength - CGFloat(6), 57)
            self.resetZone.frame = CGRectMake(self.resetZone.frame.origin.x , self.resetZone.frame.origin.y, self.signalPathLength - CGFloat(10), 10)
            
            }, completion: nil)
        
        theEndOfSignalPathX = signalPathX + signalPath.frame.width
    }
    
    func makeBackLineFlexible(){
        
        previousTheEndOfBackLineX = theEndOfBackLineX
        
        let length = getBackLinesLength()
        
        backLineX = signalPath.frame.origin.x + signalPath.frame.width
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
            
            self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, length , 3)
            
            }, completion: nil)
        
        theEndOfBackLineX = backLineX + backLine.frame.width
        
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
        if selectedBlock.backgroundColor == UIColor.redColor(){
            selectedBlock.removeFromSuperview()
        }
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

            resetAllLinesLengthAndCulculatesBlocks()
            setBlocksRelativePositionToPath(button)
            
            
            if  button.center.y < signalPath.frame.origin.y + signalPath.frame.height / 2 - resetZone.frame.height / 2
            {
                UIView.animateWithDuration(0.2, delay: 0, options: .TransitionCurlUp , animations: {
                    self.alignArrayOfBlocks(self.blockOnSecondPath)
              
                    }, completion: nil)
                
            } else if button.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2 + resetZone.frame.height / 2

            {
                UIView.animateWithDuration(0.2, delay: 0, options: .TransitionCurlUp , animations: {
                    self.alignArrayOfBlocks(self.blockOnFirstPath)

                    }, completion: nil)
                
            }
            else if  button.frame.intersects(resetZone.frame) {
                UIView.animateWithDuration(0.2, delay: 0, options: .TransitionCurlUp , animations: {
                   //self.makeSignalPathsFlexible()
                    self.resetAllLinesLengthAndCulculatesBlocks()
                    
                    }, completion: nil)
            }
        }
    }
    
    // Model
    func setBlocksRelativePositionToPath(button: UIButton){
        let buttonRightSideX: CGFloat = button.frame.origin.x + blockWidth
        let accuracy : CGFloat = 10
        let rightReferencePoint = CGPoint(x: buttonRightSideX - accuracy, y: button.center.y)
        let leftReferencePoint = CGPoint(x: button.frame.origin.x + accuracy, y: button.center.y)
        findLengthChangeOfLines()
        if totalChangedLength == 0 {
            print("case one")
            
            for block in self.view.subviews {

                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && button.frame.contains(block.center){
                    
                    // 水平左右互換
                    if block.center.x < button.center.x && block.frame.contains(rightReferencePoint) && blockDragedLength < 0
                        

                    {
                        print("1-1")
                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                            block.center = CGPoint(x: block.center.x + self.blockSpace + block.frame.width - 1, y: block.center.y)
                            
                           // if block.center
                            }, completion: nil)
                        putOutSideBlocksBackToSignalPath()
                        putOutSideBlocksBackToBackLine()
                        
                        alignEverything()
                        
                    }
                        
                    else if block.center.x > button.center.x && block.frame.contains(leftReferencePoint) && blockDragedLength > 0
                    {
                        print("1-2")
                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                            block.center = CGPoint(x: block.center.x - self.blockSpace - block.frame.width + 1, y: block.center.y)
                        
                            }, completion: nil)
                        putOutSideBlocksBackToSignalPath()
                        putOutSideBlocksBackToBackLine()
        
                        alignEverything()
                    }
                    
                    else {
                        
                        if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x && block.frame.intersects(backLine.frame) {
                            
                            print("case 1-3")
                            
                            if backLineChangedLength > 0 {
                                UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                                    block.center.x += self.backLineChangedLength
                                    
                                    }, completion: nil)
                                
                            } else if backLineChangedLength < 0 {
                                UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
                                    block.center.x += self.backLineChangedLength + 1
                                    self.alignEverything()
                                    }, completion: nil)
                                
                            }
                            
                        }
                        print("case 1-4")
                    }
                }
            }
        }
        
        // 垂直插入移除新方塊
        else if totalChangedLength != 0
        {
            print("case two")
            for block in self.view.subviews {
                

                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x {
                    print("case 2-2")
                    if totalChangedLength > 0 {
                        print("case 2-2-1")
                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
                            block.center.x += self.totalChangedLength
                            
                            //self.putOutSideBlocksBackToFrontkLine()
                            self.putOutSideBlocksBackToBackLine()
                            //self.alignEverything()
                            
                            }, completion: nil)
                        
                    } else if totalChangedLength < 0 {
                        
                        if frontLineChangedLength < 0 && block.frame.intersects(frontLine.frame) {
                            print("case 2-3-2")
                            
                            UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
                                block.center.x += self.frontLineChangedLength + 1
                                self.putOutSideBlocksBackToFrontkLine()
                                //self.putOutSideBlocksBackToBackLine()
                                self.alignEverything()
                                }, completion: nil)
                            //
                        }
                        
                        else if backLineChangedLength < 0 && block.frame.intersects(backLine.frame) {
                            print("case 2-3-1")
                            
                            
                            UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
                                block.center.x += self.backLineChangedLength + 1
                                
                                }, completion: nil)
                            
                            self.getFrontLinesLength()
                             UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {

                            self.putOutSideBlocksBackToBackLine()
                            self.alignEverything()
                            }, completion: nil)
                        }
//                            else if frontLineChangedLength < 0 && block.frame.intersects(frontLine.frame) {
//                            print("case 2-3-2")
//                            
//                            UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
//                                block.center.x += self.backLineChangedLength + 1
//                                self.putOutSideBlocksBackToFrontkLine()
//                                //self.putOutSideBlocksBackToBackLine()
//                                self.alignEverything()
//                                }, completion: nil)
////
//                        }
                        
//                        else {
//                        print("case 2-3-3")
//                        UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
//                            block.center.x += self.totalChangedLength + 1
//                      
//                            self.alignEverything()
//   
//                            }, completion: nil)
//                        }
                    }
                    
                }
//                else if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x && block.frame.intersects(backLine.frame) {
//                        
//                        print("case 2-1")
//                        
//                        if backLineChangedLength > 0 {
//                            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                                block.center.x += self.backLineChangedLength
//                                self.putOutSideBlocksBackToFrontkLine()
//                                self.putOutSideBlocksBackToBackLine()
//                                
//                                }, completion: nil)
//                            
//                        } else if backLineChangedLength < 0 {
//                            UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
//                                block.center.x += self.backLineChangedLength + 1
//                                self.putOutSideBlocksBackToFrontkLine()
//                                self.putOutSideBlocksBackToBackLine()
//                                self.alignEverything()
//                                }, completion: nil)
//                            
//                        }
//                        else {
//                            print("case 2-1-e")
//                        }
//                        
//                }
                
            }

            
//            for block in self.view.subviews {
//                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x {
//                    if totalChangedLength > 0 {
//                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                            block.center.x += self.totalChangedLength
//                            }, completion: nil)
//                        
//                    } else if totalChangedLength < 0 {
//                        UIView.animateWithDuration(0.4, delay: 0, options: .CurveLinear , animations: {
//                        block.center.x += self.totalChangedLength + 1
//                        self.alignEverything()
//                            }, completion: nil)
//                        
//                    }
//                   
//                }
//                
//            }

        }
        
    }
 


    
    func putOutSideBlocksBackToFrontkLine(){
        for block in self.view.subviews {
            
            if block.isKindOfClass(UIButton) && block.frame.width == blockWidth {
                
                let rightSide = block.frame.origin.x + block.frame.width
                
                if block.center.y == frontLine.center.y {
                    // on right side
                    
                    if block.frame.origin.x > frontLine.frame.origin.x + frontLine.frame.width && block.frame.origin.x + block.frame.width < signalPath.center.x {
                        block.center.x = frontLine.frame.origin.x + frontLine.frame.width - 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnFrontLine)
                    }
                
     
                    else if rightSide < frontLine.frame.origin.x  {
                            
                            block.center.x = backLine.frame.origin.x + 1
                            resetAllLinesLengthAndCulculatesBlocks()
                            alignArrayOfBlocks(blockOnFrontLine)
                        
                    }
                }
            }
        }
    }

    func putOutSideBlocksBackToSignalPath(){
        for block in self.view.subviews {
            
            if block.isKindOfClass(UIButton) && block.frame.width == blockWidth  {
                // OnFirstPath
                if block.center.y == signalPath.frame.origin.y {
                    // on left side
                    if block.frame.origin.x < signalPath.frame.origin.x {
                        block.center.x = signalPath.frame.origin.x + 1
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnFirstPath)
                        
                    }
                        
                        // on right side
                    else if block.frame.origin.x + block.frame.width > signalPath.frame.origin.x  + signalPath.frame.width {
                        block.center.x = signalPath.frame.origin.x + signalPath.frame.width - 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnFirstPath)
                    }
                    
                    
                }
                    // OnSecondPath
                else if block.center.y == signalPath.frame.origin.y + signalPath.frame.height {
                    // on left side
                    if block.frame.origin.x < signalPath.frame.origin.x {
                        
                        block.center.x = signalPath.frame.origin.x + 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnSecondPath)
                        
                    }
                        // on right side
                    else if block.frame.origin.x + block.frame.width > signalPath.frame.origin.x  + signalPath.frame.width {
                        block.center.x = signalPath.frame.origin.x + signalPath.frame.width - 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnSecondPath)
                    }
                    
                }
            }
        }
    }
    
    func putOutSideBlocksBackToBackLine(){
        for block in self.view.subviews {
            
            if block.isKindOfClass(UIButton) && block.frame.width == blockWidth  {
                let rightSide = block.frame.origin.x + block.frame.width
              
                if block.center.y == backLine.center.y {
                    //&& block.center.x > backLine.frame.origin.x
                    // on right side
                    
                    if block.frame.origin.x > backLine.frame.origin.x + backLine.frame.width {
                        block.center.x = backLine.frame.origin.x + backLine.frame.width - 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnBackLine)
                    }
                    
                    // on left side
                    
                    else if rightSide < backLine.frame.origin.x && block.frame.origin.x > signalPath.center.x  {
                        
                        
                        block.center.x = backLine.frame.origin.x + 1
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnBackLine)
                    }
                    
                }
            }
        }
    }
    
    func alignArrayOfBlocks(views: [UIView]){
        var viewsDictionary = [CGFloat: UIView]()
        
        if views.count > 0 {
            
            for i in 0...views.count - 1 {
                
                viewsDictionary[views[i].center.x] = views[i]
                
            }
            
            let orderedViews = viewsDictionary.sort { $0.0 < $1.0 }
            
            if views == blockOnSecondPath || views == blockOnFirstPath {
                
                orderedViews[0].1.center.x = signalPath.frame.origin.x + CGFloat(50)
                
                for i in 0...orderedViews.count - 1 {
                    
                    orderedViews[i].1.center.x = orderedViews[0].1.center.x + CGFloat(i) * (blockWidth + blockSpace)
                    
                    if orderedViews[i].1.center.y < signalPath.frame.origin.y + signalPath.frame.height / 2
                    {
                        orderedViews[i].1.center.y = signalPath.frame.origin.y
                    } else if orderedViews[i].1.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2
                    {
                        orderedViews[i].1.center.y = signalPath.frame.origin.y + signalPath.frame.height
                    }
                }
            }
                
            else if views == blockOnFrontLine {
                
                orderedViews[0].1.center.x = frontLine.frame.origin.x + CGFloat(blockSpace) + blockWidth / 2
                
                for i in 0...orderedViews.count - 1 {
                    orderedViews[i].1.center.x = orderedViews[0].1.center.x + CGFloat(i) * (blockWidth + blockSpace)
                    orderedViews[i].1.center.y = frontLine.center.y
                }
            }
                
            else if views == blockOnBackLine {
                orderedViews[0].1.center.x = backLine.frame.origin.x + CGFloat(blockSpace) + 6
                
                for i in 0...orderedViews.count - 1 {
                    orderedViews[i].1.center.x = orderedViews[0].1.center.x + CGFloat(i) * (blockWidth + blockSpace)
                    orderedViews[i].1.center.y = backLine.center.y
                }
                
            }
        }
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

    
    func findLengthChangeOfLines(){
        frontLineChangedLength = theEndOfFrontLineX - previousTheEndOfFrontLineX
        signalPathChangedLength = theEndOfSignalPathX - previousTheEndOfSignalPathX
        backLineChangedLength = theEndOfBackLineX - previousTheEndOfBackLineX
        totalChangedLength = theEndOfBackLineX - previousTheEndOfBackLineX
        
    }
    
    func getFrontLinesLength() -> CGFloat {
        var totalLengthOfFrontLine: CGFloat = 21
        var result = CGFloat()
        blockOnFrontLine = []
        
        let previousFrontLineLength = frontLineLength
        
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && frontLine.frame.intersects(block.frame)
            {
                totalLengthOfFrontLine += block.frame.width
                blockOnFrontLine.append(block)
            }
        }
            result = totalLengthOfFrontLine + blockSpace * CGFloat(blockOnFrontLine.count)
            frontLineLength = result
            print(blockOnFrontLine.count)
            frontLineChangedLength = frontLineLength - previousFrontLineLength
        
        return frontLineLength
    }
    
    func getBackLinesLength() -> CGFloat {
        var totalLengthOfBackLine: CGFloat = 21
        var result = CGFloat()

        blockOnBackLine = []
        
        let previousBackLineLength = backLineLength
        
        for block in self.view.subviews {
            if block.isKindOfClass(UIButton) && backLine.frame.intersects(block.frame) {
                totalLengthOfBackLine += block.frame.width
                blockOnBackLine.append(block)
            }
        }
  
            result = totalLengthOfBackLine + blockSpace * CGFloat(blockOnBackLine.count)
            backLineLength = result
            backLineChangedLength = backLineLength - previousBackLineLength
 
        return backLineLength
    }
    
    func getSingalPathLength() -> CGFloat {
        var totalLenghOfBlocksForFirstPath: CGFloat = 40
        var totalLenghOfBlocksForSecondPath: CGFloat = 40
        blockOnFirstPath = []
        blockOnSecondPath = []
        
        for block in self.view.subviews {
            // blocks on first Path
            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y < signalPath.frame.origin.y + signalPath.frame.height / 2 - resetZone.frame.height / 2
            {
                totalLenghOfBlocksForFirstPath += block.frame.width
                blockOnFirstPath.append(block)

            }
                
                // blocks on the second Path
            else if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2 + resetZone.frame.height / 2
            {
                totalLenghOfBlocksForSecondPath += block.frame.width
                blockOnSecondPath.append(block)

            }
            
        }
        
        var result = CGFloat()
        
        if totalLenghOfBlocksForFirstPath >= totalLenghOfBlocksForSecondPath {
            result = totalLenghOfBlocksForFirstPath + blockSpace * CGFloat(blockOnFirstPath.count)
        } else {
            result = totalLenghOfBlocksForSecondPath + blockSpace * CGFloat(blockOnSecondPath.count)
        }
        
        signalPathLength = result
        return signalPathLength
    }
}

//    func insertNewBlocks(button: UIButton){
//        if frontLineChangedLength != 0 {
//            for block in self.view.subviews {
//                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x && (block.frame.intersects(frontLine.frame) || block.frame.intersects(signalPath.frame) || block.frame.intersects(backLine.frame))
//                {  UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                    block.center.x += self.frontLineChangedLength
//                    }, completion: nil)
//                }
//
//            }
//        } else if signalPathChangedLength != 0 {
//            for block in self.view.subviews {
//                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x && (block.frame.intersects(signalPath.frame) || block.frame.intersects(backLine.frame))
//                {  UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                    block.center.x += self.signalPathChangedLength
//                    }, completion: nil)
//                }
//
//            }
//        } else if backLineChangedLength != 0 {
//            for block in self.view.subviews {
//                if block.isKindOfClass(UIButton) && block.frame.intersects(backLine.frame) && block != button && block.center.x >= button.center.x
//                {  UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                    block.center.x += self.backLineChangedLength
//                    }, completion: nil)
//                }
//
//            }
//        }
//    }

//    func alignBlocks(selfButton: UIButton){
//        var previousBlock: UIButton = selfButton
//        
//        //  block  | previous
//        // previous   |    block
//        
//        if blockCount > 1 && totalChangedLength == 0 {
//            for i in 1...blockCount {
//                for block in self.view.subviews {
//                    if block.isKindOfClass(UIButton) && block.frame.width >= 80 && block != previousBlock && previousBlock.frame.intersects(block.frame) == true {
//                        
//                        let midPoint = (block.center.x + previousBlock.center.x) / 2
//                        
//                        if block.center.x >= previousBlock.center.x
//                        {
//                            
//                            //block.center.x -= blockDragedLength
//                            //                            if block.center.x == previousBlock.center.x {
//                            //                                print("+++++++++")
//                            //                                block.center.x += block.frame.width / 2
//                            //                                previousBlock.center.x -= block.frame.width / 2
//                            //                            }
//                            block.center.x = previousBlock.center.x - block.frame.width
//                            previousBlock = block as! UIButton
//                            
//                        }
//                        else if block.center.x < previousBlock.center.x
//                        {
//                            block.center.x = previousBlock.center.x + block.frame.width
//                            //previousBlock.center.x = block.center.x
//                            //previousBlock.center.x = touchPosition.x
//                            
//                            // block.center.x += blockDragedLength
//                            //                            print("========")
//                            //                             if block.center.x == previousBlock.center.x {
//                            //                                block.center.x -= block.frame.width / 2
//                            //                                previousBlock.center.x += block.frame.width / 2
//                            //
//                            //                            }
//                            
//                            
//                            //block.center.x = touchPosition.x + blockDragedLength
//                            
//                            
//                            previousBlock = block as! UIButton
//                            
//                        }
//                            
//                        else
//                        {
//                            previousBlock = block as! UIButton
//                            
//                        }
//                    }
//                }
//            }
//        }
//    }
//    



//import UIKit
//
//class ViewController: UIViewController {
//    var frontLine = UIView()
//    var signalPath = UIView()
//    var hollow = UIView()
//    var backLine = UIView()
//    var backArrow = UILabel()
//    
//    
//    var blockCount: Int = 0
//    var signalPathX: CGFloat = 162
//    var backLineX: CGFloat = 202
//    var theEndOfBackLineX: CGFloat = 302
//    var signalPathLength: CGFloat = 40
//    var frontLineLength: CGFloat = 21
//    var backLineLength: CGFloat = 100
//    
//    var selectedBlock = UIButton()
//    let blockSpace: CGFloat = 30
//    let blockWidth: CGFloat = 50
//    let movingAccuracy : CGFloat = 5
//    
//    var touchPosition = CGPoint()
//    var blockDragedLength = CGFloat()
//    
//    var previousTheEndOfBackLineX = CGFloat()
//    var changedLength = CGFloat()
//    var frontLineChangedLength = CGFloat()
//    var signalPathChangedLength = CGFloat()
//    var backLineChangedLength = CGFloat()
//    var changedView = [UIView]()
//    
//    
//    @IBAction func addBlock(sender: UIButton) {
//         let x = backLine.frame.origin.x + 10
//         let y = backLine.center.y - 20
//        addBlock(x, posY: y)
//        blockCount += 1
//    }
//    
//    @IBAction func deleteBlock(sender: UIButton) {
//        deleteBlock()
//        if blockCount > 0 {
//            blockCount -= 1
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setViews()
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            touchPosition = touch.locationInView(view)
//            deSelect(touchPosition)
//            
//        }
//    }
//
//    // View
//    func setViews(){
//        frontLine.frame = CGRectMake(141, 100, 21, 3)
//        frontLine.backgroundColor = UIColor.grayColor()
//        view.addSubview(frontLine)
//
//        signalPath.frame = CGRectMake(162, 70, 40, 63)
//        signalPath.backgroundColor = UIColor.grayColor()
//        view.addSubview(signalPath)
//        
//        hollow.frame = CGRectMake(3, 3, 34, 57)
//        hollow.backgroundColor = UIColor.whiteColor()
//        signalPath.addSubview(hollow)
//        
//        backLine.frame = CGRectMake(202, 100, 100, 3)
//        backLine.backgroundColor = UIColor.grayColor()
//        view.addSubview(backLine)
//        
//        backArrow.frame = CGRectMake(300, 93, 29, 18)
//        backArrow.text = "➤"
//        backArrow.textColor = UIColor.lightGrayColor()
//        view.addSubview(backArrow)
//    }
//    
//    func makeFrontLineFlexible(){
//        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//            self.frontLine.frame = CGRectMake(self.frontLine.frame.origin.x, self.frontLine.frame.origin.y, self.getLinesLength(self.frontLine, lengthOffset: 21), 3)
//            
//            }, completion: nil)
//    }
//    
//    func makeSignalPathsFlexible(){
//        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//            self.signalPathX = self.frontLine.frame.origin.x + self.frontLine.frame.width
//            self.signalPath.frame = CGRectMake(self.signalPathX, self.signalPath.frame.origin.y, self.getSingalPathLength(), 63)
//            self.hollow.frame = CGRectMake(self.hollow.frame.origin.x , self.hollow.frame.origin.y, self.signalPathLength - CGFloat(6), 57)
//            }, completion: nil)
//    }
//    
//    func makeBackLineFlexible(){
//        backLineX = signalPathX + signalPath.frame.width
//        let lengthOffset: CGFloat = 100
//        
//        if checkBlockOnPath(backLine) == true {
//            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: lengthOffset) - lengthOffset, 3)
//                }, completion: nil)
//            calculateTheEndOfBackLineX()
//            
//        } else {
//            UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                self.backLine.frame = CGRectMake(self.backLineX, self.backLine.frame.origin.y, self.getLinesLength(self.backLine, lengthOffset: lengthOffset), 3)
//                }, completion: nil)
//            calculateTheEndOfBackLineX()
//        }
//    }
//    
//    func moveBackArrow(){
//        let backArrowX = backLine.frame.origin.x + backLine.frame.width
//        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//            self.backArrow.center = CGPoint(x: backArrowX + 10, y: self.backLine.center.y)
//            }, completion: nil)
//    }
//
//    
//    // Controller
//    func addBlock(posX: CGFloat, posY: CGFloat){
//        let block = UIButton()
//        alertForInputName(block)
//        block.frame = CGRectMake(posX, posY, blockWidth, 40)
//        block.backgroundColor = UIColor.grayColor()
//        block.titleLabel!.adjustsFontSizeToFitWidth = true
//        
//        block.addTarget(self, action: #selector(ViewController.dragBlock(_:event:)), forControlEvents: UIControlEvents.TouchDragInside)
//        block.addTarget(self, action: #selector(ViewController.touchBlock(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(block)
//        
//    }
//    
//    func alertForInputName(button: UIButton){
//        let alert = UIAlertController(title: "Input Name", message: "Please give a name showing on the block", preferredStyle: .Alert)
//        alert.addTextFieldWithConfigurationHandler({(textField) -> Void in
//            textField.text = "FX-1"
//        })
//        
//        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: {(action) -> Void in
//            let textField = alert.textFields![0] as UITextField
//            button.setTitle(textField.text, forState: .Normal)
//        }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    func deleteBlock(){
//        selectedBlock.removeFromSuperview()
//        makeFrontLineFlexible()
//        makeSignalPathsFlexible()
//        makeBackLineFlexible()
//        moveBackArrow()
//        //setBlocksRelativePositionToPath(button)
//        
//    }
//    
//    func touchBlock(button: UIButton){
//        selectedBlock = button
//        selectedBlock.backgroundColor = UIColor.redColor()
//        for block in self.view.subviews {
//            if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != selectedBlock {
//                block.backgroundColor = UIColor.lightGrayColor()
//            }
//        }
//    }
//    
//    func deSelect(touch: CGPoint){
//        for view in self.view.subviews {
//            if view.frame.contains(touch) == false {
//                selectedBlock.backgroundColor = UIColor.lightGrayColor()
//                
//            }
//        }
//    }
//    
//    func dragBlock(button: UIButton, event: UIEvent){
//        selectedBlock = button
//        
//        // make block moves
//        for touch in event.touchesForView(button)!{
//            let previousLocation: CGPoint = touch.previousLocationInView(button)
//            let location: CGPoint = touch.locationInView(button)
//            let deltaX: CGFloat = location.x - previousLocation.x
//            let deltaY: CGFloat = location.y - previousLocation.y
//            button.center = CGPointMake(button.center.x + deltaX, button.center.y + deltaY)
//            blockDragedLength = deltaX
//
//            makeFrontLineFlexible()
//            makeSignalPathsFlexible()
//            makeBackLineFlexible()
//            moveBackArrow()
//            setBlocksRelativePositionToPath(button)
//        }
//    }
//    
//    // Model
//    func setBlocksRelativePositionToPath(button: UIButton){
//        let buttonRightSideX: CGFloat = button.frame.origin.x + blockWidth
//        //let buttonLeftMidlePoint: CGPoint = CGPoint(x: button.frame.origin.x, y: button.center.y)
//        let rightReferencePoint = CGPoint(x: buttonRightSideX - movingAccuracy, y: button.center.y)
//        let leftReferencePoint = CGPoint(x: button.frame.origin.x + movingAccuracy, y: button.center.y)
//        
//        checkWhichLengthChange()
//        
////        // not on Changed View
//
////    for block in self.view.subviews {
//        // if changedLength == 0 {
////                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && button.frame.contains(block.center){
////                    
////                    if block.center.x < button.center.x && block.frame.contains(rightReferencePoint) && blockDragedLength < 0
////                        
////                    {
////                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
////                            block.center = CGPoint(x: block.center.x + self.blockSpace + block.frame.width, y: block.center.y)
////                            }, completion: nil)
////                    }
////                    
////                    else if block.center.x > button.center.x && block.frame.contains(leftReferencePoint) && blockDragedLength > 0
////                    {
////                        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
////                            block.center = CGPoint(x: block.center.x - self.blockSpace - block.frame.width, y: block.center.y)
////                            }, completion: nil)
////                    }
////                }
////            }
////        } else
////            
////        {
//        lengthChange()
//            for block in self.view.subviews {
//                
//                if block.isKindOfClass(UIButton) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x
//                    
//                    // check each block on which individual length, if the blocks on moved part, all blocks of right side needs to move according to the moveing part
//                    
//                {  UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear , animations: {
//                    
//                    block.center.x += self.changedLength
//                    }, completion: nil)
//                }
//            }
//        }
//        
//    //}
//    
//    
//    
//    
//    
//    func calculateTheEndOfBackLineX(){
//        theEndOfBackLineX = backLineX + backLine.frame.width
//    }
//    
//    func checkWhichLengthChange() -> [UIView] {
//        
//        if frontLineChangedLength != 0 {
//            changedView.append(frontLine)
//        }
//        else if frontLineChangedLength != 0 {
//            changedView.append(signalPath)
//         
//        } else if backLineLength != 0 {
//            changedView.append(backLine)
//        }
//        //changedLength = frontLineChangedLength + frontLineChangedLength + backLineLength
//        return changedView
//    }
//    
//    func lengthChange(){
//        changedLength = theEndOfBackLineX - previousTheEndOfBackLineX
//        
//    }
//    
//    func getLinesLength(line: UIView, lengthOffset: CGFloat) -> CGFloat {
//        let previousFrontLineLength = frontLineLength
//        let previousBackLineLength = backLineLength
//        
//        var totalLenghOfLine: CGFloat = lengthOffset
//        var blockCountsOnLine: Int = 0
//        
//        for block in self.view.subviews {
//            if block.isKindOfClass(UIButton) && line.frame.intersects(block.frame)
//            {
//                totalLenghOfLine += block.frame.width
//                blockCountsOnLine += 1
//            }
//        }
//        let result: CGFloat = totalLenghOfLine + blockSpace * CGFloat(blockCountsOnLine)
//        if line == frontLine {
//            frontLineLength = result
//            frontLineChangedLength = frontLineLength - previousFrontLineLength
//        } else if line == backLine {
//            backLineLength = result
//            backLineChangedLength = backLineLength - previousBackLineLength
//        }
//        
//        return result
//    }
//    
//    func getSingalPathLength() -> CGFloat {
//        var totalLenghOfBlocksForFirstPath: CGFloat = 40
//        var totalLenghOfBlocksForSecondPath: CGFloat = 40
//        var blockCountsOnFirstPath: Int = 0
//        var blockCountsOnSecondPath: Int = 0
//        let previousSignalPathLength = signalPathLength
//        
//        for block in self.view.subviews {
//            // blocks on first Path
//            if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y <= signalPath.frame.origin.y + signalPath.frame.height / 2
//            {
//                totalLenghOfBlocksForFirstPath += block.frame.width
//                blockCountsOnFirstPath += 1
//            }
//                
//                // blocks on the second Path
//            else if block.isKindOfClass(UIButton) && signalPath.frame.intersects(block.frame) && block.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2
//            {
//                totalLenghOfBlocksForSecondPath += block.frame.width
//                blockCountsOnSecondPath += 1
//            }
//        }
//        
//        var result = CGFloat()
//        if totalLenghOfBlocksForFirstPath >= totalLenghOfBlocksForSecondPath {
//            result = totalLenghOfBlocksForFirstPath + blockSpace * CGFloat(blockCountsOnFirstPath)
//        } else {
//            result = totalLenghOfBlocksForSecondPath + blockSpace * CGFloat(blockCountsOnSecondPath)
//        }
//        
//        signalPathLength = result
//        signalPathChangedLength = signalPathLength - previousSignalPathLength
//        
//        return signalPathLength
//    }
//    
//    
//    func checkBlockOnPath(part: UIView) -> Bool {
//        var result = false
//        for block in self.view.subviews {
//            if block.isKindOfClass(UIButton) && part.frame.intersects(block.frame) == true
//            {
//                result =  true
//            }
//        }
//        return result
//    }
//}
//
