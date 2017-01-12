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
    
    @IBAction func addBlock(_ sender: UIButton) {
        demoBlock.removeFromSuperview()
        
        let x = backLine.frame.origin.x + 10
        let y = backLine.center.y - 20
        addBlock(x, posY: y)
        blockCount += 1
        alignEverything()
        
    }
    
    @IBAction func deleteBlock(_ sender: UIButton) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchPosition = touch.location(in: view)
            deSelect(touchPosition)
            alignEverything()

        }
    }
    
    // View
    
    func setViews(){
        frontLine.frame = CGRect(x: 141, y: 101, width: 21, height: 3)
        frontLine.backgroundColor = UIColor.gray
        view.addSubview(frontLine)
        
        signalPath.frame = CGRect(x: 162, y: 70, width: 40, height: 63)
        signalPath.backgroundColor = UIColor.gray
        view.addSubview(signalPath)
        
        hollow.frame = CGRect(x: 3, y: 3, width: 34, height: 57)
        hollow.backgroundColor = UIColor.white
        signalPath.addSubview(hollow)
        
        resetZone.frame = CGRect(x: 5, y: 25, width: 30, height: 10)
        resetZone.backgroundColor = UIColor.clear
        signalPath.addSubview(resetZone)
        
        
        backLine.frame = CGRect(x: 202, y: 100, width: 21, height: 3)
        backLine.backgroundColor = UIColor.gray
        view.addSubview(backLine)
        
        backArrow.frame = CGRect(x: 300, y: 93, width: 29, height: 18)
        backArrow.text = "➤"
        backArrow.textColor = UIColor.lightGray
        view.addSubview(backArrow)
        
        let x = backLine.frame.origin.x + 10
        let y = backLine.center.y - 20
        demoBlock.frame = CGRect(x: x, y: y, width: blockWidth, height: 40)
        demoBlock.backgroundColor = UIColor.clear
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
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
            
            self.frontLine.frame = CGRect(x: frontLineX, y: self.frontLine.frame.origin.y, width: length, height: 3)
            
            }, completion: nil)
        
        theEndOfFrontLineX = frontLineX + length
    }
    
    func makeSignalPathsFlexible(){
        previousTheEndOfSignalPathX = theEndOfSignalPathX
        
        signalPathX = frontLine.frame.origin.x + frontLine.frame.width
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
            
            self.signalPath.frame = CGRect(x: self.signalPathX, y: self.signalPath.frame.origin.y, width: self.getSingalPathLength(), height: 63)
            self.hollow.frame = CGRect(x: self.hollow.frame.origin.x , y: self.hollow.frame.origin.y, width: self.signalPathLength - CGFloat(6), height: 57)
            self.resetZone.frame = CGRect(x: self.resetZone.frame.origin.x , y: self.resetZone.frame.origin.y, width: self.signalPathLength - CGFloat(10), height: 10)
            
            }, completion: nil)
        
        theEndOfSignalPathX = signalPathX + signalPath.frame.width
    }
    
    func makeBackLineFlexible(){
        
        previousTheEndOfBackLineX = theEndOfBackLineX
        
        let length = getBackLinesLength()
        
        backLineX = signalPath.frame.origin.x + signalPath.frame.width
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
            
            self.backLine.frame = CGRect(x: self.backLineX, y: self.backLine.frame.origin.y, width: length , height: 3)
            
            }, completion: nil)
        
        theEndOfBackLineX = backLineX + backLine.frame.width
        
    }
    
    func moveBackArrow(){
        
        let backArrowX = backLine.frame.origin.x + backLine.frame.width
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
            
            self.backArrow.center = CGPoint(x: backArrowX + 10, y: self.backLine.center.y)
            
            }, completion: nil)
    }
    
    
    // Controller
    func addBlock(_ posX: CGFloat, posY: CGFloat){
        let block = UIButton()
        alertForInputName(block)
        block.frame = CGRect(x: posX, y: posY, width: blockWidth, height: 40)
        block.backgroundColor = UIColor.gray
        block.titleLabel!.adjustsFontSizeToFitWidth = true
        
        block.addTarget(self, action: #selector(ViewController.dragBlock(_:event:)), for: UIControlEvents.touchDragInside)

        block.addTarget(self, action: #selector(ViewController.touchBlock(_:)), for: UIControlEvents.touchUpInside)

        self.view.addSubview(block)
    }
    
    func alertForInputName(_ button: UIButton){
        let alert = UIAlertController(title: "Input Name", message: "Please give a name showing on the block", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.text = "FX-1"
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {(action) -> Void in
            let textField = alert.textFields![0] as UITextField
            button.setTitle(textField.text, for: UIControlState())
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteBlock(){
        if selectedBlock.backgroundColor == UIColor.red{
            selectedBlock.removeFromSuperview()
            alignEverything()
        }
    }
    
    func touchBlock(_ button: UIButton){
        selectedBlock = button
        selectedBlock.backgroundColor = UIColor.red
        for block in self.view.subviews {
            if block.isKind(of: UIButton.self) && block.frame.width == blockWidth && block != selectedBlock {
                block.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    func deSelect(_ touch: CGPoint){
        for view in self.view.subviews {
            if view.frame.contains(touch) == false {
                selectedBlock.backgroundColor = UIColor.lightGray
                
            }
        }
    }
    
    func dragBlock(_ button: UIButton, event: UIEvent){
        selectedBlock = button
        
        // make block moves
        for touch in event.touches(for: button)!{
            let previousLocation: CGPoint = touch.previousLocation(in: button)
            let location: CGPoint = touch.location(in: button)
            let deltaX: CGFloat = location.x - previousLocation.x
            let deltaY: CGFloat = location.y - previousLocation.y
            button.center = CGPoint(x: button.center.x + deltaX, y: button.center.y + deltaY)
            blockDragedLength = deltaX

            resetAllLinesLengthAndCulculatesBlocks()
            setBlocksRelativePositionToPath(button)
            
            
            if  button.center.y < signalPath.frame.origin.y + signalPath.frame.height / 2 - resetZone.frame.height / 2
            {
                UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlUp , animations: {
                    self.alignArrayOfBlocks(self.blockOnSecondPath)
              
                    }, completion: nil)
                
            } else if button.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2 + resetZone.frame.height / 2

            {
                UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlUp , animations: {
                    self.alignArrayOfBlocks(self.blockOnFirstPath)

                    }, completion: nil)
                
            }
            else if  button.frame.intersects(resetZone.frame) {
                UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCurlUp , animations: {
                   //self.makeSignalPathsFlexible()
                    self.resetAllLinesLengthAndCulculatesBlocks()
                    
                    }, completion: nil)
            }
        }
    }
    
    // Model
    func setBlocksRelativePositionToPath(_ button: UIButton){
        let buttonRightSideX: CGFloat = button.frame.origin.x + blockWidth
        let accuracy : CGFloat = 10
        let rightReferencePoint = CGPoint(x: buttonRightSideX - accuracy, y: button.center.y)
        let leftReferencePoint = CGPoint(x: button.frame.origin.x + accuracy, y: button.center.y)
        findLengthChangeOfLines()
        if totalChangedLength == 0 {
            
            for block in self.view.subviews {

                if block.isKind(of: UIButton.self) && block.frame.width == blockWidth && block != button && button.frame.contains(block.center){
                    
                    // 水平左右互換
                    if block.center.x < button.center.x && block.frame.contains(rightReferencePoint) && blockDragedLength < 0
                        

                    {
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
                            block.center = CGPoint(x: block.center.x + self.blockSpace + block.frame.width - 1, y: block.center.y)
                            
                           // if block.center
                            }, completion: nil)
                        putOutSideBlocksBackToSignalPath()
                        putOutSideBlocksBackToBackLine()
                        
                        alignEverything()
                        
                    }
                        
                    else if block.center.x > button.center.x && block.frame.contains(leftReferencePoint) && blockDragedLength > 0
                    {
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
                            block.center = CGPoint(x: block.center.x - self.blockSpace - block.frame.width + 1, y: block.center.y)
                        
                            }, completion: nil)
                        putOutSideBlocksBackToSignalPath()
                        putOutSideBlocksBackToBackLine()
        
                        alignEverything()
                    }
                    
                    else {
                        
                        if block.isKind(of: UIButton.self) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x && block.frame.intersects(backLine.frame) {
                            
                            if backLineChangedLength > 0 {
                                UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
                                    block.center.x += self.backLineChangedLength
                                    
                                    }, completion: nil)
                                
                            } else if backLineChangedLength < 0 {
                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear , animations: {
                                    block.center.x += self.backLineChangedLength + 1
                                    self.alignEverything()
                                    }, completion: nil)
                                
                            }
                            
                        }
                       
                    }
                }
            }
        }
        
        // 垂直插入移除新方塊
        else if totalChangedLength != 0
        {
           
            for block in self.view.subviews {
                

                if block.isKind(of: UIButton.self) && block.frame.width == blockWidth && block != button && block.center.x >= button.center.x {
               
                    if totalChangedLength > 0 {
                     
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear , animations: {
                            block.center.x += self.totalChangedLength
                            
                            self.putOutSideBlocksBackToBackLine()
                            
                            }, completion: nil)
                        
                    } else if totalChangedLength < 0 {
                        
                        if frontLineChangedLength < 0 {
                   
                            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear , animations: {
                                block.center.x += self.frontLineChangedLength + 1
                                self.putOutSideBlocksBackToFrontkLine()
                                self.alignEverything()
                                }, completion: nil)
                            
                        }
                        
                        else if backLineChangedLength < 0 && block.frame.intersects(backLine.frame) {
                         
                            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear , animations: {
                                block.center.x += self.backLineChangedLength + 1
                                
                                }, completion: nil)
                            
                            self.getFrontLinesLength()
                             UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear , animations: {

                            self.putOutSideBlocksBackToBackLine()
                            self.alignEverything()
                            }, completion: nil)
                        }
                    }
                    
                }
            }

        }
        
    }
 


    
    func putOutSideBlocksBackToFrontkLine(){
        for block in self.view.subviews {
            
            if block.isKind(of: UIButton.self) && block.frame.width == blockWidth {
                
                let rightSide = block.frame.origin.x + block.frame.width
                
                if block.center.y == frontLine.center.y {
                    // on right side
                
                    if block.frame.origin.x > frontLine.frame.origin.x + frontLine.frame.width  {
                        
                        block.center.x = frontLine.frame.origin.x + frontLine.frame.width - 1
                        
                        resetAllLinesLengthAndCulculatesBlocks()
                        alignArrayOfBlocks(blockOnFrontLine)
                    }
                
                        // on left side
                       
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
            
            if block.isKind(of: UIButton.self) && block.frame.width == blockWidth  {
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
            
            if block.isKind(of: UIButton.self) && block.frame.width == blockWidth  {
                let rightSide = block.frame.origin.x + block.frame.width
              
                if block.center.y == backLine.center.y {
             
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
    
    func alignArrayOfBlocks(_ views: [UIView]){
        var viewsDictionary = [CGFloat: UIView]()
        
        if views.count > 0 {
            
            for i in 0...views.count - 1 {
                
                viewsDictionary[views[i].center.x] = views[i]
                
            }
            
            let orderedViews = viewsDictionary.sorted { $0.0 < $1.0 }
            
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
    
    
    func checkBlockOnPath(_ part: UIView) -> Bool {
        var result = false
        for block in self.view.subviews {
            if block.isKind(of: UIButton.self) && part.frame.intersects(block.frame) == true
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
            if block.isKind(of: UIButton.self) && frontLine.frame.intersects(block.frame)
            {
                totalLengthOfFrontLine += block.frame.width
                blockOnFrontLine.append(block)
            }
        }
            result = totalLengthOfFrontLine + blockSpace * CGFloat(blockOnFrontLine.count)
            frontLineLength = result
  
            frontLineChangedLength = frontLineLength - previousFrontLineLength
        
        return frontLineLength
    }
    
    func getBackLinesLength() -> CGFloat {
        var totalLengthOfBackLine: CGFloat = 21
        var result = CGFloat()

        blockOnBackLine = []
        
        let previousBackLineLength = backLineLength
        
        for block in self.view.subviews {
            if block.isKind(of: UIButton.self) && backLine.frame.intersects(block.frame) {
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
            if block.isKind(of: UIButton.self) && signalPath.frame.intersects(block.frame) && block.center.y < signalPath.frame.origin.y + signalPath.frame.height / 2 - resetZone.frame.height / 2
            {
                totalLenghOfBlocksForFirstPath += block.frame.width
                blockOnFirstPath.append(block)

            }
                
                // blocks on the second Path
            else if block.isKind(of: UIButton.self) && signalPath.frame.intersects(block.frame) && block.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2 + resetZone.frame.height / 2
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

