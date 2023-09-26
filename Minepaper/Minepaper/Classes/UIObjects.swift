//
//  UIObjects.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import Foundation
import SwiftUI

class WallpaperOption: ObservableObject {
    
    init(imageName: String, uiImage: UIImage) {
        _imageName = imageName
        _uiImage = uiImage
    }
    
    var image: Image {
        get {
            return Image(uiImage: uiImage)
        }
    }
    
    private var _uiImage: UIImage = UIImage()
    var uiImage: UIImage {
        set {
            _uiImage = newValue
        }
        get {
            return _uiImage
        }
    }
    
    private var _imageName: String = ""
    var imageName: String {
        set {
            _imageName = newValue
        }
        get {
            return _imageName
        }
    }
    
    var fullImageUrl: String {
        get {
            return "\(Constants.remoteImagesFolder)/\(_imageName)"
        }
    }
}
