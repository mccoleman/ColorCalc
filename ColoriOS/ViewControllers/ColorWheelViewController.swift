//
//  ColorWheelViewController.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 5/7/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorWheelViewController: UIViewController {

    @IBOutlet var colorOutputView:UIView!
    @IBOutlet var colorWheelView:ColorWheelView!
    @IBOutlet var colorSelectorView:ColorSelectorView!
    
    @IBOutlet var complementaryButton:UIButton!
    @IBOutlet var monoButton:UIButton!
    @IBOutlet var analogousButton:UIButton!
    @IBOutlet var splitButton:UIButton!
    @IBOutlet var triadicButton:UIButton!
    @IBOutlet var tetradicButton:UIButton!
    
    @IBOutlet var lockSlider:UISwitch!
    
    var harmonyState:ColorHarmony = .None
    
    let panGestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        
        self.colorWheelView.renderColorWheel()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view {
            if self.colorWheelView.bounds.contains(viewToDrag.center){
                viewToDrag.center = CGPoint(
                    x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y
                )
                sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                self.colorOutputView.backgroundColor = self.colorWheelView.getPixelColorAt(point: viewToDrag.center)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
