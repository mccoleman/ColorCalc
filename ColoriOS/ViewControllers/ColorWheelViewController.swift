//
//  ColorWheelViewController.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 5/7/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorWheelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var colorWheelView:ColorWheelView!
    @IBOutlet var containerView:UIView!
    
    @IBOutlet var colorHueView:HueView!
    
    @IBOutlet var complementaryButton:UIButton!
    @IBOutlet var monoButton:UIButton!
    @IBOutlet var analogousButton:UIButton!
    @IBOutlet var splitButton:UIButton!
    @IBOutlet var triadicButton:UIButton!
    @IBOutlet var tetradicButton:UIButton!
    
   @IBOutlet var collectionView:UICollectionView!
    
    @IBOutlet var lockSlider:UISwitch!

    private let reuseIdentifier = "Cell"
    
    private var harmonyState:ColorHarmony = .None
    
    private let panGestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    private var selectorsArray:[ColorSelectorView] = []
    
    private var baseSelector:ColorSelectorView? = nil
    
    override func viewDidLoad() {

        self.colorWheelView.renderColorWheel()
        super.viewDidLoad()
        self.renderNewSelectorView()
        self.colorHueView!.buildGradientLayer()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view as? ColorSelectorView{
            if self.colorWheelView.bounds.contains(viewToDrag.center){
                
                let initialRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: viewToDrag.center,
                    quadrant: self.colorWheelView.quadrantInView(viewCenter: viewToDrag.center))
                
                let newCenterPoint = CGPoint(
                    x: viewToDrag.center.x + translation.x,
                    y: viewToDrag.center.y + translation.y
                )
                
                let testView = UIView()
                testView.center = newCenterPoint

                let newQuadarant = self.colorWheelView.quadrantInView(viewCenter: newCenterPoint)
                
                let newRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: testView.center,
                    quadrant: newQuadarant)
                
                if newRadiusAngle.radius < (self.colorWheelView.frame.width/2) {
                    sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                    viewToDrag.color = self.colorWheelView.getPixelColorAt(point: testView.center)
                    viewToDrag.center = newCenterPoint
                    self.baseSelector = viewToDrag
                    
                    let radiusChange = initialRadiusAngle.radius - newRadiusAngle.radius
                    let angleChange = initialRadiusAngle.angle - newRadiusAngle.angle
                    print("\(radiusChange) ___ \(angleChange)")
                    if lockSlider.isOn{
                        for selector in selectorsArray {
                            if selector != baseSelector {
                                let selectorRadiusAngle = getRadiusAndAngle(
                                    center: self.colorWheelView.center,
                                    basePoint: selector.center,
                                    quadrant: self.colorWheelView.quadrantInView(viewCenter: selector.center)
                                )
                                
                                let newSelectorPoint = getPointFromAngleAndRadius(
                                    angle: selectorRadiusAngle.angle - angleChange,
                                    radius: selectorRadiusAngle.radius - radiusChange,
                                    center: self.colorWheelView.center)
                                
                                selector.center = newSelectorPoint
                                selector.color = self.colorWheelView.getPixelColorAt(point: selector.center)
                            }
                        }
                        self.colorHueView.color = viewToDrag.color
                    }
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    @IBAction func harmonySelected(sender: UIButton){
        if let baseSelector = self.baseSelector, let harmony:ColorHarmony = ColorHarmony(rawValue: sender.tag){
        
            let points = getOriginsForColorHarmony(
                center: colorWheelView.center, basePoint:
                baseSelector.center,
                quadrant: colorWheelView.quadrantInView(viewCenter: baseSelector.center),
                harmony: harmony
            )
            
            for point in points{
                let newColorSector = ColorSelectorView(
                    frame: CGRect(
                        x: point.x - (SELECTOR_SIZE/2),
                        y: point.y - (SELECTOR_SIZE/2),
                        width: SELECTOR_SIZE,
                        height: SELECTOR_SIZE
                    ),
                    color: self.colorWheelView.getPixelColorAt(point: point)
                )

                self.addColorSelectorPanRecognizer(colorSelector: newColorSector)
                self.selectorsArray.append(newColorSector)
                self.colorWheelView.addSubview(newColorSector)
            }
            self.collectionView.reloadData()
        }
    }
    
    func renderNewSelectorView(){
        
        let newColorSector = ColorSelectorView(
            frame: CGRect(
                x: colorWheelView.center.x - (SELECTOR_SIZE/2),
                y: colorWheelView.center.y - (SELECTOR_SIZE/2),
                width: SELECTOR_SIZE,
                height: SELECTOR_SIZE
            )
        )
        
        self.addColorSelectorPanRecognizer(colorSelector: newColorSector)
        self.selectorsArray.append(newColorSector)
        self.colorWheelView.addSubview(newColorSector)
    }
    

    func addColorSelectorPanRecognizer(colorSelector:ColorSelectorView){
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panView(_:))))
        colorSelector.addGestureRecognizer(panGesture)
    }
    
    
    /*DATA SOURCE*/

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.selectorsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ColorOutputCell {
            cell.backgroundColor = self.selectorsArray[indexPath.row].color
            cell.hexLabel.text = self.selectorsArray[indexPath.row].color.hex
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        }
        
    }
}
