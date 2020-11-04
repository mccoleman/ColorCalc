//
//  ViewController.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 5/6/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit
import ColorThiefSwift

class ImageChoiceViewController: UIViewController, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {

    let imagePicker:UIImagePickerController = UIImagePickerController()
    var palette:[MMCQ.Color] = []
    @IBOutlet var spinner:UIActivityIndicatorView?
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var colorCollection:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
    }


    @IBAction func showImagePicker(){
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true) {
            self.spinner?.isHidden = false
            self.spinner?.startAnimating()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true) {
            if let image = self.imageView.image {
                self.palette = ColorThief.getPalette(from: image, colorCount: 6)!
                self.colorCollection?.reloadData()
            }
        }
//           dismiss(animated: true, completion: nil)
    }
    
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.spinner?.stopAnimating()
        self.spinner?.isHidden = true
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palette.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row <= palette.count {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorOutputCell {
                cell.color = palette[indexPath.row].makeUIColor()
                cell.backgroundColor = cell.color
                return cell
            }
        }
        return UICollectionViewCell()
    }
       
}

