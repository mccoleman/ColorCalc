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
                viewToDrag.center = CGPoint(
                    x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y
                )
                sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                viewToDrag.color = self.colorWheelView.getPixelColorAt(point: viewToDrag.center)
                
//                var radiusToCenter
                let width = abs(colorWheelView.frame.width/2 - viewToDrag.center.x)
                let height = abs(colorWheelView.frame.width/2 - viewToDrag.center.y)
                
                let radius = hypot(width, height)
                var angle:CGFloat = 0
                let quadrant = self.colorWheelView.quadrantInView(view: viewToDrag)
                switch quadrant{
                case .I, .III:
                    angle = ((acos(width/radius)*180)/CGFloat.pi) + 90*CGFloat(quadrant.rawValue-1)
                    print("\(quadrant) radius:\(radius) angle:\(angle)")
                case .II, .IV:
                    angle = ((acos(height/radius)*180)/CGFloat.pi) + 90*CGFloat(quadrant.rawValue-1)
                    print("\(quadrant) radius:\(radius) angle:\(angle)")
                }
                self.baseSelector = viewToDrag
        
            }
        }
    }
    
    @IBAction func harmonySelected(sender: UIButton){
        if let harmony:ColorHarmony = ColorHarmony(rawValue: sender.tag){
            self.harmonyState = harmony
            switch harmony{
            case .Complementary:
                self.renderCompelmentarySelectorView()
//            case .Mono:
            case .Analogous:
                self.renderAnalogousSelectorView()
    //            case .Split:
            case .Triadic:
                self.renderTriadicSelectorView()
            case .Tetradic:
                self.renderTetradicSelectorView()
            default:
                return
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
    
    func renderCompelmentarySelectorView(){
        
        if let baseSelector = self.baseSelector {
        
            let point = complementaryOrigin(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(view: baseSelector)
            )
            
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
        } else {
            
        }
    }
    
    func renderAnalogousSelectorView(){
        
        if let baseSelector = self.baseSelector {
        
            let points = analogousOrigins(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(view: baseSelector)
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
            
        } else {
            
        }
    }
    
    func renderTriadicSelectorView(){
        
        if let baseSelector = self.baseSelector {
        
            let points = triadicOrigins(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(view: baseSelector)
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
            
        } else {
            
        }
    }
    
    func renderTetradicSelectorView(){
        
        if let baseSelector = self.baseSelector {
        
            let points = tetradicOrigins(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(view: baseSelector)
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
            
        } else {
            
        }
    }
    
    func addColorSelectorPanRecognizer(colorSelector:ColorSelectorView){
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panView(_:))))
        colorSelector.addGestureRecognizer(panGesture)
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
