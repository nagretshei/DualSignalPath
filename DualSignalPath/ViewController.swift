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
    
    var needToLengthenThePath = false
    
    var x: CGFloat = 100
    var y: CGFloat = 100
    var panCenter = CGPointZero

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
        for touch in event.touchesForView(button)!{
            let previousLocation: CGPoint = touch.previousLocationInView(button)
            let location: CGPoint = touch.locationInView(button)
            let deltaX: CGFloat = location.x - previousLocation.x
            let deltaY: CGFloat = location.y - previousLocation.y
            button.center = CGPointMake(button.center.x + deltaX, button.center.y + deltaY)
                
            var totalLenghOfBlocks: CGFloat = 0
            var signalPathOrigin = CGPoint()
            for block in self.view.subviews {
                if block.isKindOfClass(UIButton) && signalPath.frame.contains(button.center) {
                    totalLenghOfBlocks += block.frame.width
                    //signalPathOrigin = block
                }
            }

            signalPath.frame = CGRectMake(270, 72,totalLenghOfBlocks + 60, 128)


        }
    }
    

    
    func deleteBlock(){
        if self.view.subviews.last!.isKindOfClass(UIButton) {
                self.view.subviews.last!.removeFromSuperview()
            }
    }
}

