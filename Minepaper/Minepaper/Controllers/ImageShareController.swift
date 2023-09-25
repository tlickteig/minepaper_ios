//
//  ImageShareController.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import Foundation
import UIKit

class ImageShareController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageToShare = UIImage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setImage(image: UIImage) {
        imageToShare = image
    }
    
    @IBAction func shareImage(_ sender: UIButton) {
        let items = [imageToShare]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
