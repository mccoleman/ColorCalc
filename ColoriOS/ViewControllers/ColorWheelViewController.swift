//
//  ColorWheelViewController.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 5/7/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorWheelViewController: UIViewController {

    @IBOutlet var colorWheelView:ColorWheelView!
    @IBOutlet var containerView:UIView!
    
    @IBOutlet var colorsStackView:UIStackView!
    
    @IBOutlet var complementaryButton:UIButton!
    @IBOutlet var monoButton:UIButton!
    @IBOutlet var analogousButton:UIButton!
    @IBOutlet var splitButton:UIButton!
    @IBOutlet var triadicButton:UIButton!
    @IBOutlet var tetradicButton:UIButton!
    
    @IBOutlet var lockSlider:UISwitch!

    
    var harmonyState:ColorHarmony = .None
    
    let panGestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    var selectorsArray:[ColorSelectorView] = []
    var colorOutputViewArray:[ColorOutputView] = []
    
    var baseSelector:ColorSelectorView? = nil
    
    
    override func viewDidLoad() {

        self.colorWheelView.renderColorWheel()
        super.viewDidLoad()
        self.renderNewSelectorView()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view as? ColorSelectorView{
            if self.colorWheelView.bounds.contains(viewToDrag.center){
                
                let initialRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: viewToDrag.center,
                    quadrant: self.colorWheelView.quadrantInView(view: viewToDrag))
                
                viewToDrag.center = CGPoint(
                    x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y
                )
                sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                viewToDrag.color = self.colorWheelView.getPixelColorAt(point: viewToDrag.center)
                self.baseSelector = viewToDrag
                let newQuadarant = self.colorWheelView.quadrantInView(view: viewToDrag)
                
                let newRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: viewToDrag.center,
                    quadrant: newQuadarant)
                
//                print("i:\(initialRadiusAngle) n:\(newRadiusAngle)")
                
                let radiusChange = initialRadiusAngle.radius - newRadiusAngle.radius
                let angleChange = initialRadiusAngle.angle - newRadiusAngle.angle
                print("\(radiusChange) ___ \(angleChange)")
                if lockSlider.isOn{
                    for selector in selectorsArray {
                        if selector != baseSelector {
                            let selectorRadiusAngle = getRadiusAndAngle(
                                center: self.colorWheelView.center,
                                basePoint: selector.center,
                                quadrant: self.colorWheelView.quadrantInView(view: selector)
                            )
                       
                            let newSelectorPoint = getPointFromAngleAndRadius(
                                angle: selectorRadiusAngle.angle - angleChange,
                                radius: selectorRadiusAngle.radius - radiusChange,
                                center: self.colorWheelView.center)
                            
                            selector.center = newSelectorPoint
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func harmonySelected(sender: UIButton){
        if let baseSelector = self.baseSelector, let harmony:ColorHarmony = ColorHarmony(rawValue: sender.tag){
        
            let points = getOriginsForColorHarmony(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(view: baseSelector),
                harmony: harmony
            )
            
            for point in points{
                let newColorSector = ColorSelectorView(
                    frame: CGRect(
                        x: point.x,
                        y: point.y,
                        width: 14,
                        height: 14
                    )
                )

                self.addColorSelectorPanRecognizer(colorSelector: newColorSector)
                self.selectorsArray.append(newColorSector)
                self.colorWheelView.addSubview(newColorSector)
            }
        }
    }
    
    func renderNewSelectorView(){
        
        let newColorSector = ColorSelectorView(
            frame: CGRect(
                x: colorWheelView.center.x,
                y: colorWheelView.center.y,
                width: 14,
                height: 14
            )
        )
        
        self.addColorSelectorPanRecognizer(colorSelector: newColorSector)
        self.colorWheelView.addSubview(newColorSector)
        self.colorsStackView.addArrangedSubview(newColorSector.colorOutput)
    }
    

    func addColorSelectorPanRecognizer(colorSelector:ColorSelectorView){
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panView(_:))))
        colorSelector.addGestureRecognizer(panGesture)
    }
}
