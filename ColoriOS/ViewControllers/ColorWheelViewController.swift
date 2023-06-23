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
    
    @IBOutlet var colorHueView:HueView!
    
    @IBOutlet var complementaryButton:UIButton!
    @IBOutlet var monoButton:UIButton!
    @IBOutlet var analogousButton:UIButton!
    @IBOutlet var splitButton:UIButton!
    @IBOutlet var triadicButton:UIButton!
    @IBOutlet var tetradicButton:UIButton!
    
   @IBOutlet var collectionView:UICollectionView!
    
    @IBOutlet var lockSlider:UISwitch!
    
    @IBOutlet var hueSlider:UIView!
    
    var colorPalette:ColorPallette!

    private let reuseIdentifier = "Cell"
    private var harmonyState:ColorHarmony = .None
    private let panGestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    private var brightness:CGFloat = 1.0
    private var selectorsArray:[ColorSelectorView] = []
   
    private var baseSelector:ColorSelectorView? = nil {
        didSet{
            for selector in self.selectorsArray {
                if selector != self.baseSelector {
                    selector.layer.borderWidth = 2
                } else {
                    self.baseSelector!.layer.borderWidth = 3
                }
            }
            self.colorHueView.color = self.baseSelector!.color//.colorWithBrightness(brightness: self.brightness)
        }
    }
    
    override func viewDidLoad() {
        self.colorWheelView.renderColorWheel()
        super.viewDidLoad()
        self.renderNewSelectorView()
        self.colorHueView.buildGradientLayer()
        let sliderGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panHueSlider(_:))))
        self.hueSlider.addGestureRecognizer(sliderGesture)
    }
    

    @objc func panColorWheelView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view as? ColorSelectorView{
            if self.colorWheelView.bounds.contains(viewToDrag.center){
                
                let initialRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: viewToDrag.center,
                    quadrant: self.colorWheelView.quadrantInView(viewCenter: viewToDrag.center))
                
                let newCenterPoint = CGPoint(
                    x: abs(viewToDrag.center.x + translation.x),
                    y: viewToDrag.center.y + translation.y
                )
                
                let newQuadarant = self.colorWheelView.quadrantInView(viewCenter: newCenterPoint)
                
                var newRadiusAngle = getRadiusAndAngle(
                    center: colorWheelView.center,
                    basePoint: newCenterPoint,
                    quadrant: newQuadarant)
                
                newRadiusAngle.radius = min(self.colorWheelView.frame.width/2-0.5,newRadiusAngle.radius)
                
                let newTruePoint = getPointFromAngleAndRadius(
                    angle: newRadiusAngle.angle,
                    radius: newRadiusAngle.radius,
                    center: self.colorWheelView.center)
                
                if newRadiusAngle.radius < (self.colorWheelView.frame.width/2) {
                    sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
                    viewToDrag.color = self.colorWheelView.getPixelColorAt(point: newTruePoint)//.colorWithBrightness(brightness: self.brightness)
                    viewToDrag.center = newTruePoint
                    self.baseSelector = viewToDrag
                    let radiusChange = initialRadiusAngle.radius - newRadiusAngle.radius
                    let angleChange = initialRadiusAngle.angle - newRadiusAngle.angle
                        
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
                                    radius: min(self.colorWheelView.frame.width/2-0.5,selectorRadiusAngle.radius - radiusChange),
                                    center: self.colorWheelView.center)
                                
                                selector.center = newSelectorPoint
                                selector.color = self.colorWheelView.getPixelColorAt(point: selector.center)//.colorWithBrightness(brightness: self.brightness)
                            }
                        }
                        self.colorHueView.color = viewToDrag.color
                    }
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    @objc func panHueSlider(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.view == self.hueSlider {
            let newCenter = CGPoint(
                x: self.hueSlider.center.x + translation.x,
                y: self.hueSlider.center.y
            )
            
            
            let xposition:CGFloat = self.hueSlider.convert(newCenter, to: colorHueView).x
               
            if xposition >= 0.0 && xposition <= colorHueView.bounds.width*2 {
                
                self.hueSlider.center = newCenter
                
                sender.setTranslation(CGPoint(x: 0, y: 0), in: self.hueSlider)
                
                self.brightness = 1-(xposition/(colorHueView.bounds.width*2))
                
                if let baseSelector = self.baseSelector {
                    self.hueSlider.backgroundColor = baseSelector.color
                }
                
                self.collectionView.reloadData()
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
                    color: self.colorWheelView.getPixelColorAt(point: point)//.colorWithBrightness(brightness:self.brightness)
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
        self.baseSelector = newColorSector
    }
    

    func addColorSelectorPanRecognizer(colorSelector:ColorSelectorView){
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panColorWheelView(_:))))
        colorSelector.addGestureRecognizer(panGesture)
    }
    
}

extension ColorWheelViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.selectorsArray.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row < self.selectorsArray.count, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ColorOutputCell {
            cell.backgroundColor = self.selectorsArray[indexPath.row].color
            cell.hexLabel.text = self.selectorsArray[indexPath.row].color.hex
            
            if self.selectorsArray[indexPath.row] == self.baseSelector {
                cell.layer.borderWidth = 3
            } else {
                cell.layer.borderWidth = 2
            }
            
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath)
        }
        
    }
}

extension ColorWheelViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.reuseIdentifier == "AddCell" {
                self.renderNewSelectorView()
            } else if cell.reuseIdentifier == reuseIdentifier {
                self.baseSelector = self.selectorsArray[indexPath.row]
            }
            
            self.collectionView.reloadData()

        }
    }
}
