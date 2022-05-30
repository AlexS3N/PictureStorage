//
//  ImageZoom.swift
//  PictureStorage
//
//  Created by Mac on 7.02.22.
//

import UIKit

class ImageZoom: UIView {


    @IBOutlet weak var zoomScrollView: ImageZoomView!
    
    @IBOutlet weak var imageViewXib: UIImageView!
    static func instanceFromNib() -> ImageZoom {
        guard let view = UINib(nibName: "ImageZoom", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ImageZoom else {
            return ImageZoom()
        }
        return view
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        removeFromSuperview()
    }
}
