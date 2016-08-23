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
    var SignalPathLengh: CGFloat = 40
    var needToStretchThePath = true
    var x: CGFloat = 100
    var y: CGFloat = 100

    @IBAction func addBlock(sender: UIButton) {
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

        block.addTarget(self, action: #selector(ViewController.changeBlockPosition(_:event:)), forControlEvents: UIControlEvents.TouchDragInside)
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
    
    func changeBlockPosition(button: UIButton, event: UIEvent){
        // make block moves
        for touch in event.touchesForView(button)!{
            let previousLocation: CGPoint = touch.previousLocationInView(button)
            let location: CGPoint = touch.locationInView(button)
            let deltaX: CGFloat = location.x - previousLocation.x
            let deltaY: CGFloat = location.y - previousLocation.y
            button.center = CGPointMake(button.center.x + deltaX, button.center.y + deltaY)
            
            
            
            // make signalPath strech
            if needToStretchThePath == true {
                SignalPathLengh = getSingalPathLength(button)
                signalPath.frame = CGRectMake(270, 72, SignalPathLengh, 128)
            }
        }
    }
    
    func getSingalPathLength(button: UIButton) -> CGFloat {
        
        var totalLenghOfBlocksForFirstPath: CGFloat = 0
        var totalLenghOfBlocksForSecondPath: CGFloat = 0
        for block in self.view.subviews {
            // on first Path
            if block.isKindOfClass(UIButton) && signalPath.frame.contains(button.center) && block.center.y <= signalPath.frame.origin.y + signalPath.frame.height / 2
            {
                totalLenghOfBlocksForFirstPath += block.frame.width
            }
                
            // on the second Path
            else if block.isKindOfClass(UIButton) && signalPath.frame.contains(button.center) && block.center.y > signalPath.frame.origin.y + signalPath.frame.height / 2
            {
                totalLenghOfBlocksForSecondPath += block.frame.width
            }
        }
        
        var result: CGFloat = 20
        if totalLenghOfBlocksForFirstPath >= totalLenghOfBlocksForSecondPath {
            result = totalLenghOfBlocksForFirstPath + 40
        } else {
            result = totalLenghOfBlocksForSecondPath + 40
        }
        return result
    }
    
    func deleteBlock(){
        if self.view.subviews.last!.isKindOfClass(UIButton) {
                self.view.subviews.last!.removeFromSuperview()
            }
    }
}

